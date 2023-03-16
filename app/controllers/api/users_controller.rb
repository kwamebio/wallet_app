class Api::UsersController < ApiController
    before_action :authenticate, only: [:update]

    def create
      @user = User.create(user_params)
      if @user.valid?
        render json: { message: 'User created successfully' }, status: :created
      else
        render json: {
          message: 'Could not create user',
          errors: @user.errors.full_messages
        }, status: :bad_request
      end
    end
  
    def update
      @user.update(user_params)
      if @user.valid?
        render json: { message: 'User updated successfully' }, status: :ok
      else
        render json: {
          message: 'Could not update user',
          errors: @user.errors.full_messages
        }, status: :bad_request
      end
    end
  
    def user_params
      password = params[:password]
      if password.present? && password.length < 6
        return render json: { message: 'Password must be at least 6 characters' }
      end
  
      {
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        dob: params[:dob],
        address: params[:address]
      }.compact
    end
end