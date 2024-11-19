module Platform
  module Actions
    module ShareOrders
      class Accept < Actor
        input :share_order, type: Marketplace::ShareOrder, allow_nil: ServiceActorArguments::FORBID_NIL_VALUES
        input :user, type: Platform::User

        def call
          fail!(error: "Can not accept order in #{share_order.state} state") unless can_accept?

          accept!
        end

        private

        def can_accept?
          share_order.registered?
        end

        def accept!
          share_order.update!(
            state: :accepted,
            modified_by: user
          )
        end
      end
    end
  end
end
