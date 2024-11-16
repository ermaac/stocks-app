class Platform::Api::V1::ShareOrdersController < Platform::Api::BaseController
  def index
    render json: current_tenant.share_orders.recent.opened.as_json(methods: :user)
  end
end
