module Marketplace
  module Actions
    class RegisterShareOrder < Actor
      include ServiceActorArguments

      input :share_order, type: Marketplace::ShareOrder, allow_nil: FORBID_NIL_VALUES
      input :organization, type: Organization, allow_nil: FORBID_NIL_VALUES

      def call
        ActiveRecord::Base.transaction do
          actor = Commands::BlockOrganizationSharesAmount.result(organization: organization, shares_amount: share_order.shares_amount)
          next_state = actor.success? ? :registered : :closed
          share_order.update!(state: next_state)
        end
      end
    end
  end
end
