class Marketplace::Api::BaseController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_user!

  def current_user
    @authenticated_user
  end

  protected

  def authenticate_user!
    authenticate_or_request_with_http_basic("Marketplace API") do |username, password|
      user = Marketplace::User.find_by(username: username)
      @authenticated_user = user if user&.authenticate(password)
      return render json: {}, status: :unauthorized unless @authenticated_user

      @authenticated_user
    end
  end
end
