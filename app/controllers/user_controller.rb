class UserController < ApplicationController
  # Register a new user
  def register
    @user = User.new(user_params)
    if @user.save
      token = @user.generate_jwt
      render json: { token: token }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # User login
  def login
    # Check for missing email or password
    if params[:email].blank? || params[:password].blank?
      return render json: { error: 'Please provide email and password' }, status: :bad_request
    end

    user = User.find_by(email: params[:email].downcase)  # Case-insensitive search
    if user&.authenticate(params[:password])
      token = user.generate_jwt
      render json: { access_token: token, message: 'Login Successful' }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # Protected action (assuming you have a JWT authentication mechanism)
  def protected_action
    render json: { message: 'You have passed' }
  end

  private

  # Permit parameters for user creation
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end
end