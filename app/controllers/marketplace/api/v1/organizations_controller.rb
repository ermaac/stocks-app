class Marketplace::Api::V1::OrganizationsController < ApplicationController
  def index
    render json: Organization.all
  end
end
