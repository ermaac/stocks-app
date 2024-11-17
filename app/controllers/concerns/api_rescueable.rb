module ApiRescueable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |error|
      render json: {}, status: :internal_server_error
    end
    rescue_from ActiveRecord::RecordNotFound do
      render json: {}, status: :not_found
    end
    rescue_from ServiceActor::ArgumentError, ServiceActor::Failure do
      render json: {}, status: :unprocessable_entity
    end
  end
end
