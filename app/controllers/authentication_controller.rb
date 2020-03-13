class AuthenticationController < ApplicationController
  def create
    if generate_jwt
      render json: { jwt: new_jwt }, status: :created
    else
      render json: { message: 'credentials invalid' }, status: :unauthorized
    end
  end

  private

  def generate_jwt
    return if user.blank?

    new_jwt
  end

  def user
    @user ||= User.authenticate(credentials[:email], credentials[:password])
  end

  def credentials
    params.require(:user).permit(:email, :password)
  end

  def new_jwt
    @new_jwt ||= user.generate_jwt
  end
end 
