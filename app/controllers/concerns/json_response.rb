# frozen_string_literal: true

# Module to response with json
module JsonResponse
  extend ActiveSupport::Concern

  #
  # Render a successful JSON response.
  #
  # @param [Hash] data the response data
  # @param [String] message optional success message
  # @param [Symbol,Integer] status HTTP status code
  # @return [void]
  #
  def render_json_success(data: {}, message: 'Success', status: :ok)
    render json: {
      status: 'success',
      message: message,
      data: data
    }, status: status
  end

  # Render an error JSON response.
  #
  # @param [Array<String>] errors list of error messages
  # @param [String] message optional error message
  # @param [Symbol,Integer] status HTTP status code
  # @return [void]
  #
  def render_json_error(errors: [], message: 'Error', status: :unprocessable_entity)
    render json: {
      status: 'error',
      message: message,
      errors: errors
    }, status: status
  end
end
