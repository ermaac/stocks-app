module Marketplace
  module Actions
    class CreateShareOrder < Actor
      input :shares_amount, type: Integer
      input :price_per_share, type: Integer
      input :organization, type: Organization
      input :user, type: Marketplace::User

      output :share_order

      def call
        self.share_order = create_share_order
        Marketplace::RegisterShareOrderJob.perform_async(organization.id, self.share_order.id) if self.share_order
      end

      private

      def create_share_order
        Marketplace::ShareOrder.create!(
          shares_amount: shares_amount,
          price_per_share: price_per_share,
          organization: organization,
          user: user,
          order_type: Marketplace::ShareOrder.order_type.default_value,
          state: Marketplace::ShareOrder.state.default_value
        )
      end
    end
  end
end
