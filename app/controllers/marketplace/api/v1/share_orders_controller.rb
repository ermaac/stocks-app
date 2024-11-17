class Marketplace::Api::V1::ShareOrdersController < Marketplace::Api::BaseController
  def create
    @result = Marketplace::Actions::CreateShareOrder.result(
      **share_order_params,
      organization: organization,
      user: current_user
    )
    return render json: {}, status: :unprocessable_entity if @result.failure?

    render json: Marketplace::ShareOrderSerializer.new(@result.share_order)
  end

  private

  def organization
    Organization.find(params[:organization_id])
  end

  def share_order_params
    params.permit(:price_per_share, :shares_amount)
  end
end
