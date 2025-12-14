# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        include UserResponse
        # Override create
        def create
          user = User.new(sign_up_params)

          if user.save
            # Generate DeviseTokenAuth tokens
            token = user.create_new_auth_token

            render_json_success(
              data: format_user_response(user, token),
              message: 'User created successfully',
              status: :created
            )
          else
            render_json_error(errors: user.errors.full_messages.uniq, message: 'User creation failed')
          end
        end

        private

        # Strong parameters for sign up
        def sign_up_params
          params.require(:registration).permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :country
          )
        end
      end
    end
  end
end
