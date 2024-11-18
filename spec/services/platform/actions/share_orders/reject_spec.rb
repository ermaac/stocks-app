require 'rails_helper'

RSpec.describe Platform::Actions::ShareOrders::Reject do
  let(:user) { create(:platform_user) }
  let(:share_order) { create(:marketplace_share_order, state: initial_state) }
  let(:actor) { described_class.call(share_order: share_order, user: user) }

  describe '#call' do
    subject { actor }

    context 'when the share order is in a registered state' do
      let(:initial_state) { :registered }

      it 'updates the share order state to rejected' do
        expect { subject }.to change { share_order.reload.state }.from('registered').to('rejected')
        expect(share_order.reload.modified_by).to eq(user)
      end

      it 'does not raise any errors' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when the share order is not in a registered state' do
      let(:initial_state) { :pending }

      it 'does not update the share order state' do
        expect { subject }.to raise_error(ServiceActor::Failure).and(not_change { share_order.reload.state })
      end

      it 'raises an appropriate error message' do
        expect { subject }.to raise_error(ServiceActor::Failure, /Can not reject order in pending state/)
      end
    end
  end
end
