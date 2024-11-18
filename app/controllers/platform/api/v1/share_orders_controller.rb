class Platform::Api::V1::ShareOrdersController < Platform::Api::BaseController
  before_action :load_share_order, only: %i[accept reject]

  def index
    @share_orders = current_tenant.share_orders.recent.opened.includes(:user)
    render json: Platform::ShareOrderSerializer.new(@share_orders)
  end

  def accept
    Platform::Actions::ShareOrders::Accept.call(share_order: @share_order, user: current_user)
    render json: Platform::ShareOrderSerializer.new(@share_order.reload)
  end

  def reject
    Platform::Actions::ShareOrders::Reject.call(share_order: @share_order, user: current_user)
    render json: Platform::ShareOrderSerializer.new(@share_order.reload)
  end

  private

  def load_share_order
    @share_order = current_tenant.share_orders.find(params[:id])
  end
end
