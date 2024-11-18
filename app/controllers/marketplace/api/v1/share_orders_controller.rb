class Marketplace::Api::V1::ShareOrdersController < Marketplace::Api::BaseController
  def create
    @result = Marketplace::Actions::CreateShareOrder.call(
      **share_order_params,
      user: current_user
    )

    render json: Marketplace::ShareOrderSerializer.new(@result.share_order)
  end

  private

  def share_order_params
    params.permit(:price_per_share, :shares_amount, :organization_id)
      .with_defaults(price_per_share: nil, shares_amount: nil, organization_id: nil)
  end
end
