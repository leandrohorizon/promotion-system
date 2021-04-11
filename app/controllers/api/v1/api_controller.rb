class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  respond_to :json

  private

  def not_found_error
    head 404
  end
end
