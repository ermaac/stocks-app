require 'rails_helper'

RSpec.describe Marketplace::Commands::BlockOrganizationSharesAmount do
  let(:organization) { create(:organization, available_shares_amount: 500, blocked_shares_amount: 100) }

  describe '.call' do
    context 'when blocking shares is possible' do
      it 'successfully blocks the specified shares amount' do
        result = described_class.call(shares_amount: 200, organization: organization)

        expect(result).to be_success
        organization.reload
        expect(organization.available_shares_amount).to eq(300)
        expect(organization.blocked_shares_amount).to eq(300)
      end
    end

    context 'when the available shares amount is insufficient' do
      it 'fails with an error' do
        result = described_class.result(shares_amount: 600, organization: organization)

        expect(result).to be_failure
        expect(result.error).to eq('Insufficient shares amount')
        organization.reload
        expect(organization.available_shares_amount).to eq(500)
        expect(organization.blocked_shares_amount).to eq(100)
      end
    end

    context 'when shares_amount is zero or negative' do
      it 'fails with an error for zero shares' do
        expect {
          described_class.call(shares_amount: 0, organization: organization)
        }.to raise_error(ServiceActor::ArgumentError, /The value "shares_amount" must be positive/)
      end

      it 'fails with an error for negative shares' do
        expect {
          described_class.call(shares_amount: -10, organization: organization)
        }.to raise_error(ServiceActor::ArgumentError, /The value "shares_amount" must be positive/)
      end
    end

    context 'when organization is missing' do
      it 'raises a validation error' do
        expect {
          described_class.call(shares_amount: 100, organization: nil)
        }.to raise_error(ServiceActor::ArgumentError, /The value "organization" cannot be empty/)
      end
    end
  end
end
