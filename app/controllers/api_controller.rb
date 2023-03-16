class ApiController < ActionController::Base
    skip_before_action :verify_authenticity_token
  
    rescue_from StandardError, with: :handle_api_error
  
    def handle_api_error(e)
        # byebug
      case e
      when ActionController::ParameterMissing
        render json: { message: param_missing_message(e.message) }, status: :bad_request
      when JWT::ExpiredSignature
        render json: { message: 'Token has expired' }, status: :bad_request
      when JWT::DecodeError
        render json: { message: 'Token is invalid' }, status: :bad_request
      else
        render json: { message: 'Internal Server Error' }, status: :internal_server_error
      end
  
      Rails.logger.error(e) if Rails.env.development?
    end
  
    def param_missing_message(message)
      if message.match?(/empty: password/)
        'Password is missing'
      elsif message.match?(/empty: email/)
        'Email is missing'
      elsif message.match?(/empty: first_name/)
        'First name is missing'
      elsif message.match?(/empty: last_name/)
        'Last name is missing'
      elsif message.match?(/empty: status/)
        'status is missing'
      elsif message.match?(/empty: name/)
        'name is missing'
      elsif message.match?(/empty: cvv/)
        'cvv is missing'
      elsif message.match?(/empty: number/)
        'number is missing'
      elsif message.match?(/empty: expiry_month/)
        'expiry_month is missing'
      elsif message.match?(/empty: expiry_year/)
        'expiry_year is missing'
      else
        'Missing parameter'
      end
    end
  
    def authenticate
      token = request.headers['Authorization']&.split&.last
      return render json: { message: 'No token provided' } if token.blank?
  
      payload = TokenService.decode(token)
      user_id = payload[0]['id']
      @user = User.find(user_id)
    end
end