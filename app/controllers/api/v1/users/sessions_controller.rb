# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController
        include UserResponse
        # Override create (sign in)
        def create
          email = sign_up_params[:email]
          password = sign_up_params[:password]

          if email.blank? || password.blank?
            return render_json_error(
              message: 'Sign in Failed',
              status: :bad_request,\
              errors: ['Email and password are required']
            )
          end

          user = User.find_for_database_authentication(email: email)

          if user&.valid_password?(password)
            # Generate token for user
            token = user.create_new_auth_token

            render_json_success(
              data: format_user_response(user, token),
              message: 'Signed in successfully'
            )
          else
            render_json_error(
              message: 'Sign in failed',
              status: :unauthorized,
              errors: ['Invalid Credentials']
            )
          end
        end

        private

        # Strong parameters for sign in
        def sign_up_params
          params.require(:auth).permit(:email, :password)
        end
      end
    end
  end
end
