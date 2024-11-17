class Platform::Api::BaseController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ApiRescueable

  before_action :authenticate_user!

  # TODO: handle with acts_as_tenant
  def current_tenant
    @current_tenant ||= Organization.first
  end

  def current_user
    @authenticated_user
  end

  protected

  def authenticate_user!
    authenticate_or_request_with_http_basic("Marketplace API") do |email, password|
      user = Platform::User.find_by(email: email)
      @authenticated_user = user if user&.authenticate(password)
      return render json: {}, status: :unauthorized unless @authenticated_user

      @authenticated_user
    end
  end
end
