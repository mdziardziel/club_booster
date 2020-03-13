class UsersController < ApiAuthorizedController

  def index
    render json: users
  end

  def show
    render json: user
  end

  private

  def user
    User.find(params[:id])
  end

  def users
    User.all
  end
end