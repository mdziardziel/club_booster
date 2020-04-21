class UsersController < ApiAuthorizedController
  SERIALIZE_ATTRIBUTES = %w(age name surname birth_date personal_description career_description email avatar_url)

  def show
    if params[:id] == 'current'
      render json: current_user.attributes.slice(*SERIALIZE_ATTRIBUTES)
    else
      render json: {}
    end
  end
end
