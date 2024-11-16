class Marketplace::Api::V1::OrganizationsController < ApplicationController
  before_action :load_organization, only: %i[share_orders]

  def index
    render json: Organization.all
  end

  def share_orders
    render json: Marketplace::ShareOrder.recent.completed.buy_orders.where(organization: @organization)
  end

  private

  def load_organization
    @organization = Organization.find_by(id: params[:id])
  end
end
