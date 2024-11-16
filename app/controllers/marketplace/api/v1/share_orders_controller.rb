class Marketplace::Api::V1::ShareOrdersController < ApplicationController
  def create
    result = Marketplace::Actions::CreateShareOrder.result(
      **share_order_params,
      organization: organization,
      user: user
    )
    return render json: {}, status: :unprocessable_entity if result.failure?

    render json: result.share_order
  end

  private

  def organization
    Organization.find_by(id: params[:organization_id])
  end

  def user
    Marketplace::User.find_by(id: params[:user_id])
  end

  def share_order_params
    params.permit(:price_per_share, :shares_amount)
  end
end
