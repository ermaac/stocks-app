class Platform::Api::BaseController < ApplicationController
  # TODO: handle with acts_as_tenant
  def current_tenant
    @current_tenant ||= Organization.first
  end
end
