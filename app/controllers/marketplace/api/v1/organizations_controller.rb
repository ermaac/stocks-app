class Marketplace::Api::V1::OrganizationsController < Marketplace::Api::BaseController
  before_action :load_organization, only: %i[share_orders]

  def index
    @organizations = Organization.all
    render json: OrganizationSerializer.new(@organizations)
  end

  def share_orders
    @share_orders = Marketplace::ShareOrder.recent.completed.buy_orders.where(organization: @organization)
    render json: Marketplace::ShareOrderSerializer.new(@share_orders)
  end

  private

  def load_organization
    @organization = Organization.find_by(id: params[:id])
  end
end
