require 'rails_helper'
require_relative '../shared_examples'

RSpec.describe "Marketplace::Api::V1::OrganizationsController", type: :request do
  let!(:user) { create(:marketplace_user) }
  let(:valid_auth_headers) { { Authorization: "Basic #{Base64.strict_encode64("#{user.username}:#{user.password}")}" } }
  let(:invalid_auth_headers) { { Authorization: "Basic #{Base64.strict_encode64("#{user.username}:wrongpassword")}" } }
  let(:auth_headers) { {} }
  let!(:organization) { create(:organization) }
  let(:endpoint_path) { "/marketplace/api/v1/organizations/#{organization.id}/share_orders" }

  describe "GET /marketplace/api/v1/organizations/:id/share_orders" do
    context "when authorization header is not provided" do
      let(:auth_headers) { {} }

      it_behaves_like 'unauthenticated api request'
    end

    context 'when authorization header is provided' do
      context 'and credentials are invalid' do
        let(:auth_headers) { invalid_auth_headers }

        it_behaves_like 'unauthenticated api request'
      end

      context 'and credentials are valid' do
        let(:auth_headers) { valid_auth_headers }

        it_behaves_like 'authenticated api request'

        context 'when organization_id matches' do
          let!(:completed_share_order) { create(:marketplace_share_order, state: :completed, organization: organization) }
          let!(:pending_share_order) { create(:marketplace_share_order, state: :pending, organization: organization) }

          it 'returns list of completed orders' do
            get endpoint_path, headers: auth_headers

            json_response = JSON.parse(response.body)
            expect(json_response).to include(hash_including(completed_share_order.as_json.slice('id', 'shares_amount', 'price_per_share')))
            expect(json_response).not_to include(hash_including('id' => pending_share_order.id))
          end
        end

        context 'when organization_id does not match' do
          let!(:another_organization) { create(:organization) }
          let!(:another_organization_completed_share_order) { create(:marketplace_share_order, state: :completed, organization: another_organization) }

          it 'does not return order of the other organization' do
            get endpoint_path, headers: auth_headers

            json_response = JSON.parse(response.body)
            expect(json_response).not_to include(hash_including('id' => another_organization_completed_share_order.id))
          end
        end

        context 'when organization does not exist' do
          let(:endpoint_path) { "/marketplace/api/v1/organizations/0/share_orders" }

          it 'returns response with :not_found status' do
            get endpoint_path, headers: auth_headers

            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end
end
