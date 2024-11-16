class Platform::Api::BaseController < ApplicationController
  # TODO: handle with acts_as_tenant
  def current_tenant
    @current_tenant ||= Organization.first
  end

  # TODO: handle via authenticated user
  def current_user
    current_tenant.users.first
  end
end
