require 'rails_helper'

RSpec.describe Platform::Actions::ShareOrders::Accept do
  let(:user) { create(:platform_user) }
  let(:share_order) { create(:marketplace_share_order, state: initial_state) }
  let(:actor) { described_class.call(share_order: share_order, user: user) }

  describe '#call' do
    subject { actor }

    context 'when the share order is registered' do
      let(:initial_state) { :registered }

      it 'updates the share order state to completed' do
        expect { subject }.to change { share_order.reload.state }.from('registered').to('completed').and(
          change { Marketplace::PurchasedShare.count }.by(1)
        )
        expect(share_order.reload.modified_by).to eq(user)
      end

      it 'does not raise any errors' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when the share order is not registered' do
      let(:initial_state) { :completed }

      it 'does not update the share order state' do
         expect { subject }.to raise_error(ServiceActor::Failure).and(not_change { share_order.reload.state })
      end

      it 'fails with an appropriate error message' do
        expect { subject }.to raise_error(ServiceActor::Failure, /Can not accept order in completed state/)
      end
    end
  end
end
