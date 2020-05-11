class UsersController < ApiAuthorizedController
  SERIALIZE_ATTRIBUTES = %w(age name surname birth_date personal_description career_description email avatar_url)

  def show
    if params[:id] == 'current'
      render json: current_user.attributes.slice(*SERIALIZE_ATTRIBUTES)
    else
      render json: {}
    end
  end

  def update
    current_user.update!(update_params)
    respond_with current_user, { data_attributes: [:name, :surname, :personal_description, :career_description, :avatar_url] }
  end

  private

  def update_params
    params.require(:user).permit(:name, :surname, :personal_description, :career_description, :avatar_url) 
  end
end
