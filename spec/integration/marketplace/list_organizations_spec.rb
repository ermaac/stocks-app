require 'rails_helper'
require_relative '../shared_examples'

RSpec.describe "Marketplace::Api::V1::OrganizationsController", type: :request do
  let!(:user) { create(:marketplace_user) }
  let(:valid_auth_headers) { { Authorization: "Basic #{Base64.strict_encode64("#{user.username}:#{user.password}")}" } }
  let(:invalid_auth_headers) { { Authorization: "Basic #{Base64.strict_encode64("#{user.username}:wrongpassword")}" } }
  let(:auth_headers) { {} }

  let!(:organization1) { create(:organization) }
  let!(:organization2) { create(:organization) }

  let(:endpoint_path) { "/marketplace/api/v1/organizations" }

  describe "GET /marketplace/api/v1/organizations" do
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

        it 'returns list of organizations' do
          get endpoint_path, headers: auth_headers

          json_response = JSON.parse(response.body)
          expect(json_response).to include(hash_including(organization1.attributes.slice('name', 'available_shares_amount', 'price_per_share')))
          expect(json_response).to include(hash_including(organization2.attributes.slice('name', 'available_shares_amount', 'price_per_share')))
        end
      end
    end
  end
end
