module Marketplace
  module Actions
    class CreateShareOrder < Actor
      include ServiceActorArguments

      input :shares_amount, type: MUST_BE_A_NUMBER, allow_nil: FORBID_NIL_VALUES, must: { be_positive: MUST_BE_A_POSITIVE_NUMBER }
      input :price_per_share, type: MUST_BE_A_NUMBER_OR_FLOAT, allow_nil: FORBID_NIL_VALUES, must: { be_positive: MUST_BE_A_POSITIVE_NUMBER }
      input :organization_id, allow_nil: FORBID_NIL_VALUES
      input :user, type: Marketplace::User

      output :share_order

      def call
        @organization = Organization.find_by(id: organization_id)
        fail!(error: "Failed to create order: organization with ID #{organization_id} was not found") if @organization.blank?

        self.share_order = create_share_order
        Marketplace::RegisterShareOrderJob.perform_async(@organization.id, self.share_order.id) if self.share_order
      end

      private

      def create_share_order
        Marketplace::ShareOrder.create!(
          shares_amount: shares_amount,
          price_per_share: price_per_share,
          organization: @organization,
          user: user,
          order_type: Marketplace::ShareOrder.order_type.default_value,
          state: Marketplace::ShareOrder.state.default_value
        )
      end
    end
  end
end
