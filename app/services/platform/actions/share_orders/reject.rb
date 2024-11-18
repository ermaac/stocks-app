module Platform
  module Actions
    module ShareOrders
      class Reject < Actor
        input :share_order, type: Marketplace::ShareOrder
        input :user, type: Platform::User

        def call
          fail!(error: "Can not reject order in #{share_order.state} state") unless can_reject?

          reject!
        end

        private

        def can_reject?
          share_order.registered?
        end

        def reject!
          share_order.update!(
            state: :rejected,
            modified_by: user
          )
        end
      end
    end
  end
end
