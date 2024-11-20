module Platform
  module Commands
    class CreatePurchasedShare < Actor
      input :share_order, type: Marketplace::ShareOrder

      output :purchased_share, type: Marketplace::PurchasedShare

      def call
        ActiveRecord::Base.transaction do
          self.purchased_share = create_purched_share
          complete_share_order
        end
      end

      private

      def create_purched_share
        Marketplace::PurchasedShare.create!(
          user: share_order.user,
          organization: share_order.organization,
          amount: share_order.shares_amount,
          share_order: share_order
        )
      end

      def complete_share_order
        share_order.update!(
          state: :completed,
          purchased_amount: share_order.price_per_share * share_order.shares_amount
        )
      end
    end
  end
end
