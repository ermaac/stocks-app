module Marketplace
  module Actions
    class CreateShareOrder < Actor
      input :shares_amount
      input :price_per_share
      input :organization, type: Organization
      input :user, type: Marketplace::User

      output :share_order

      def call
        self.share_order = Marketplace::ShareOrder.create!(
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
