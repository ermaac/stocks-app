module Marketplace
  module Actions
    class RegisterShareOrder < Actor
      input :share_order, type: Marketplace::ShareOrder
      input :organization, type: Organization

      def call
        ActiveRecord::Base.transaction do
          actor = BlockOrganizationSharesAmount.result(organization: organization, shares_amount: share_order.shares_amount)
          next_state = actor.success? ? :registered : :closed
          share_order.update!(state: next_state)
        end
      end

      private

      def blocking_shares_possible?
        organization.available_shares_amount < shares_amount
      end

      def block_shares_amount
        organization.increment!(:blocked_shares_amount, shares_amount)
        organization.decrement!(:available_shares_amount, shares_amount)
      end
    end
  end
end
