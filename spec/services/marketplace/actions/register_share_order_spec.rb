require 'rails_helper'

RSpec.describe Marketplace::Actions::RegisterShareOrder do
  let(:organization) { create(:organization, available_shares_amount: 500, blocked_shares_amount: 100) }
  let(:share_order) { create(:marketplace_share_order, shares_amount: 200, state: :pending, organization: organization) }

  describe '.call' do
    context 'when blocking shares is successful' do
      before do
        allow(Marketplace::Commands::BlockOrganizationSharesAmount)
          .to receive(:result)
          .and_return(ServiceActor::Result.new(failure: false))
      end

      it 'transitions the share_order state to :registered' do
        result = described_class.call(share_order: share_order, organization: organization)

        expect(result).to be_success
        share_order.reload
        expect(share_order.state).to eq('registered')
      end
    end

    context 'when blocking shares fails' do
      before do
        allow(Marketplace::Commands::BlockOrganizationSharesAmount)
          .to receive(:result)
          .and_return(ServiceActor::Result.new(failure: true))
      end

      it 'transitions the share_order state to :closed' do
        result = described_class.result(share_order: share_order, organization: organization)

        expect(result).to be_success
        share_order.reload
        expect(share_order.state).to eq('closed')
      end
    end

    context 'when an error occurs during the transaction' do
      before do
        allow(Marketplace::Commands::BlockOrganizationSharesAmount)
          .to receive(:result)
          .and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises an error and does not change the share_order state' do
        expect {
          described_class.call(share_order: share_order, organization: organization)
        }.to raise_error(ActiveRecord::RecordInvalid)

        share_order.reload
        expect(share_order.state).to eq('pending')
      end
    end

    context 'when inputs are invalid' do
      let(:valid_inputs) do
        { organization: organization, share_order: share_order }
      end

      it 'raises an ArgumentError for missing share_order' do
        expect {
          described_class.call(valid_inputs.merge(share_order: nil))
        }.to raise_error(ServiceActor::ArgumentError, /The value "share_order" cannot be empty/)
      end

      it 'raises an ArgumentError for missing organization' do
        expect {
          described_class.call(valid_inputs.merge(organization: nil))
        }.to raise_error(ServiceActor::ArgumentError, /The value "organization" cannot be empty/)
      end
    end
  end
end
