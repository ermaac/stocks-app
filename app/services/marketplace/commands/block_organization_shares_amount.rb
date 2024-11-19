module Marketplace
  module Commands
    class BlockOrganizationSharesAmount < Actor
      include ServiceActorArguments

      input :shares_amount, type: MUST_BE_A_NUMBER, allow_nil: FORBID_NIL_VALUES, must: { be_positive: MUST_BE_A_POSITIVE_NUMBER }
      input :organization, type: Organization, allow_nil: FORBID_NIL_VALUES

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
