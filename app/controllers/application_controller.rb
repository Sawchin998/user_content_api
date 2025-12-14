# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JsonResponse

  before_action :convert_camel_case_params

  private

  # Converts all incoming params keys from camelCase to snake_case recursively.
  #
  # Example:
  #   { "firstName": "John", "userDetails": { "countryCode": "NP" } }
  #   becomes:
  #   { "first_name" => "John", "user_details" => { "country_code" => "NP" } }
  #
  def convert_camel_case_params
    params.deep_transform_keys! { |key| key.to_s.underscore }
  end
end
