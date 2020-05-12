class UsersController < ApiAuthorizedController
  def show
    if params[:id] == 'current'
      render json: current_user, serializer: UserSerializer
    else
      render json: {}
    end
  end

  def update
    current_user.update!(update_params)
    respond_with current_user, { data_attributes: %w(name surname personal_description career_description avatar_url birth_date) }
  end

  private

  def update_params
    params.require(:user).permit(:name, :surname, :personal_description, :career_description, :avatar_url, :birth_date) 
  end
end
