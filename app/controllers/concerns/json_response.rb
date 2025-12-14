# frozen_string_literal: true

# Module to response with json
module JsonResponse
  extend ActiveSupport::Concern

  # Use this to render a success response
  def render_json_success(data: {}, message: 'Success', status: :ok)
    render json: {
      status: 'success',
      message: message,
      data: data
    }, status: status
  end

  # Use this to render an error response
  def render_json_error(errors: [], message: 'Error', status: :unprocessable_entity)
    render json: {
      status: 'error',
      message: message,
      errors: errors
    }, status: status
  end
end
