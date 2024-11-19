require 'rails_helper'

RSpec.describe Marketplace::Actions::CreateShareOrder do
  let(:user) { create(:marketplace_user) }
  let(:organization) { create(:organization) }

  let(:shares_amount) { 100 }
  let(:price_per_share) { 50.0 }

  let(:valid_inputs) do
    {
      shares_amount: shares_amount,
      price_per_share: price_per_share,
      organization_id: organization.id,
      user: user
    }
  end

  describe '.call' do
    context 'when all inputs are valid' do
      it 'creates a new share order and enqueues the job' do
        expect(Marketplace::RegisterShareOrderJob).to receive(:perform_async).with(organization.id, kind_of(Integer))

        result = described_class.call(valid_inputs)

        expect(result).to be_success
        expect(result.share_order).to be_persisted
        expect(result.share_order.shares_amount).to eq(shares_amount)
        expect(result.share_order.price_per_share).to eq(price_per_share)
        expect(result.share_order.organization).to eq(organization)
        expect(result.share_order.user).to eq(user)
      end
    end

    context 'when organization_id is invalid' do
      it 'fails with an appropriate error' do
        invalid_inputs = valid_inputs.merge(organization_id: nil)

        expect { described_class.call(invalid_inputs) }.to raise_error(ServiceActor::ArgumentError, /The value "organization_id" cannot be empty/)
      end

      it 'fails if the organization does not exist' do
        invalid_inputs = valid_inputs.merge(organization_id: -1)

        result = described_class.result(invalid_inputs)

        expect(result).to be_failure
        expect(result.error).to eq('Failed to create order: organization with ID -1 was not found')
      end
    end

    context 'when shares_amount is not positive' do
      it 'fails with a validation error' do
        invalid_inputs = valid_inputs.merge(shares_amount: -10)

        expect {
          described_class.call(invalid_inputs)
        }.to raise_error(ServiceActor::ArgumentError, /must be positive/)
      end
    end

    context 'when price_per_share is not positive' do
      it 'fails with a validation error' do
        invalid_inputs = valid_inputs.merge(price_per_share: 0)

        expect {
          described_class.call(invalid_inputs)
        }.to raise_error(ServiceActor::ArgumentError, /must be positive/)
      end
    end

    context 'when user is missing' do
      it 'fails with a validation error' do
        invalid_inputs = valid_inputs.merge(user: nil)

        expect {
          described_class.call(invalid_inputs)
        }.to raise_error(ServiceActor::ArgumentError, /The value "user" cannot be empty/)
      end
    end
  end
end
