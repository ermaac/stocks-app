module Marketplace
  module Actions
    class BlockOrganizationSharesAmount < Actor
      input :shares_amount, type: Integer
      input :organization, type: Organization

      def call
        fail!(error: "Insufficient shares amount") unless blocking_shares_possible?

        block_shares_amount!
      end

      private

      def blocking_shares_possible?
        organization.available_shares_amount >= shares_amount
      end

      def block_shares_amount!
        Organization.update_counters(
          organization.id,
          available_shares_amount: -shares_amount,
          blocked_shares_amount: shares_amount
        )
      end
    end
  end
end
