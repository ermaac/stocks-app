class Platform::Api::BaseController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_user!

  # TODO: handle with acts_as_tenant
  def current_tenant
    @current_tenant ||= Organization.first
  end

  # TODO: handle via authenticated user
  def current_user
    current_tenant.users.first
  end

  protected

  def authenticate_user!
    authenticate_or_request_with_http_basic("Marketplace API") do |email, password|
      user = Platform::User.find_by(email: email)
      authenticated_user =  user&.authenticate(password)
      return render json: {}, status: :unauthorized unless authenticated_user

      authenticated_user
    end
  end
end
