class Api::SessionsController < ApiController
    require_relative "../../services/token_service"
    def create
      user = User.find_by(email: session_params[:email])
      return render json: { message: 'User with email does not exist' } if user.nil?
  
      user = user.authenticate(session_params[:password])
      if user.present?
        user.generate_token
        render json: { message: 'login successful', data: user }
      else
        render json: { message: 'password is invalid' }
      end
    end
  
    def session_params
      {
        email: params.require(:email),
        password: params.require(:password)
      }
    end
  end
  