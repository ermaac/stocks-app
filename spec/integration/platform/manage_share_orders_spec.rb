require 'rails_helper'
require_relative '../shared_examples'

RSpec.describe "Marketplace::Api::V1::OrganizationsController", type: :request do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:platform_user, organization: organization) }
  let(:valid_auth_headers) { { Authorization: "Basic #{Base64.strict_encode64("#{user.email}:#{user.password}")}" } }
  let(:invalid_auth_headers) { { Authorization: "Basic #{Base64.strict_encode64("#{user.email}:wrongpassword")}" } }
  let(:auth_headers) { {} }

  describe "GET /platform/api/v1/share_orders" do
    let(:endpoint_path) { "/platform/api/v1/share_orders" }

    context "when authorization header is not provided" do
      let(:auth_headers) { {} }

      it_behaves_like 'unauthenticated api request'
    end

    context 'when authorization header is provided' do
      context 'and credentials are invalid' do
        let(:auth_headers) { invalid_auth_headers }

        it_behaves_like 'unauthenticated api request'
      end

      context 'and credentials are valid credentials of marketplace api user' do
        let!(:user) { create(:marketplace_user) }

        it_behaves_like 'unauthenticated api request'
      end

      context 'and credentials are valid' do
        let(:auth_headers) { valid_auth_headers }

        it_behaves_like 'authenticated api request'

        %i[pending registered accepted rejected].each do |state|
          context "when order is in #{state} state" do
            let!(:share_order) { create(:marketplace_share_order, state: state, organization: organization) }

            it "returns response with order in #{state}" do
              get endpoint_path, headers: auth_headers

              json_response = JSON.parse(response.body)
              expect(json_response).to include(hash_including(
                share_order.as_json.slice('id', 'shares_amount', 'price_per_share').merge(
                  'buyer' => hash_including({
                    'username' => share_order.user.username
                  })
                )
              ))
            end
          end
        end
      end
    end
  end

  describe "POST /platform/api/v1/share_orders/:id/accept" do
    let(:state) { :registered }
    let!(:share_order) { create(:marketplace_share_order, state: state, organization: organization) }
    let(:endpoint_path) { "/platform/api/v1/share_orders/#{share_order.id}/accept" }

    context "when authorization header is not provided" do
      let(:auth_headers) { {} }

      it_behaves_like 'unauthenticated POST api request'
    end

    context 'when authorization header is provided' do
      context 'and credentials are invalid' do
        let(:auth_headers) { invalid_auth_headers }

        it_behaves_like 'unauthenticated POST api request'
      end

      context 'and credentials are valid credentials of marketplace api user' do
        let!(:user) { create(:marketplace_user) }

        it_behaves_like 'unauthenticated POST api request'
      end

      context 'and credentials are valid' do
        let(:auth_headers) { valid_auth_headers }

        it_behaves_like 'authenticated POST api request'

        %i[pending accepted rejected closed completed].each do |state|
          context "and order is in #{state} state" do
            let!(:share_order) { create(:marketplace_share_order, state: state, organization: organization) }

            it "returns response with unprocessable_entity status code" do
              post endpoint_path, headers: auth_headers

              json_response = JSON.parse(response.body)
              expect(response).to have_http_status(:unprocessable_entity)
              expect(json_response['error']).to eq("Can not accept order in #{share_order.state} state")
            end
          end
        end

        context 'and state is registered' do
          it 'transitions order to accepted state' do
            post endpoint_path, headers: auth_headers

            json_response = JSON.parse(response.body)
            expect(json_response['state']).to eq('accepted')
          end
        end
      end
    end
  end

  describe "POST /platform/api/v1/share_orders/:id/reject" do
    let(:state) { :registered }
    let!(:share_order) { create(:marketplace_share_order, state: state, organization: organization) }
    let(:endpoint_path) { "/platform/api/v1/share_orders/#{share_order.id}/reject" }

    context "when authorization header is not provided" do
      let(:auth_headers) { {} }

      it_behaves_like 'unauthenticated POST api request'
    end

    context 'when authorization header is provided' do
      context 'and credentials are invalid' do
        let(:auth_headers) { invalid_auth_headers }

        it_behaves_like 'unauthenticated POST api request'
      end

      context 'and credentials are valid credentials of marketplace api user' do
        let!(:user) { create(:marketplace_user) }

        it_behaves_like 'unauthenticated POST api request'
      end

      context 'and credentials are valid' do
        let(:auth_headers) { valid_auth_headers }

        it_behaves_like 'authenticated POST api request'

        %i[pending accepted rejected closed completed].each do |state|
          context "and order is in #{state} state" do
            let!(:share_order) { create(:marketplace_share_order, state: state, organization: organization) }

            it "returns response with unprocessable_entity status code" do
              post endpoint_path, headers: auth_headers

              json_response = JSON.parse(response.body)
              expect(response).to have_http_status(:unprocessable_entity)
              expect(json_response['error']).to eq("Can not reject order in #{share_order.state} state")
            end
          end
        end

        context 'and state is registered' do
          it 'transitions order to rejected state' do
            post endpoint_path, headers: auth_headers

            json_response = JSON.parse(response.body)
            expect(json_response['state']).to eq('rejected')
          end
        end
      end
    end
  end
end
