# frozen_string_literal: true

# Module to format user response
module UserResponse
  extend ActiveSupport::Concern

  #
  # Format a user object and token into a JSON:API-style response.
  #
  # @param [User] user the user object
  # @param [Hash] hash containing  bearer authentication token (JWT)
  # @return [Hash] formatted user response
  #
  def format_user_response(user, token)
    {
      id: user.id,
      type: 'users',
      attributes: {
        token: token['Authorization'],
        email: user.email,
        name: "#{user.first_name} #{user.last_name}",
        country: user.country,
        createdAt: user.created_at.iso8601,
        updatedAt: user.updated_at.iso8601
      }
    }
  end
end
