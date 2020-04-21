class UsersController < ApiAuthorizedController
  def index
    render json: current_user.attributes.
  end

  def show
    render json: current_user.event(params[:id])
  end
end
