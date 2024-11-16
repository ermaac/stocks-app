module Platform
  module Actions
    module ShareOrders
      class Reject < Actor
        input :share_order, type: Marketplace::ShareOrder
        input :user, type: Platform::User

        def call
          share_order.update!(
            state: :rejected,
            modified_by: user
          )
        end
      end
    end
  end
end
