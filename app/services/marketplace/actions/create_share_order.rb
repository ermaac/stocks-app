module Marketplace
  module Actions
    class CreateShareOrder < Actor
      input :shares_amount, type: Integer
      input :price_per_share, type: Integer
      input :organization, type: Organization
      input :user, type: Marketplace::User

      output :share_order

      def call
        ActiveRecord::Base.transaction do
          block_shares_amount
          self.share_order = create_share_order
        end
      end

      private

      def block_shares_amount
        organization.increment!(:blocked_shares_amount, shares_amount)
        organization.decrement!(:available_shares_amount, shares_amount)
      end

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
