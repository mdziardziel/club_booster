class EventsController < ApiAuthorizedController

  # def index
  #   render json: current_user.clubs
  # end

  # def show
  #   render json: club
  # end

  def create
    raise NotAuthorizedError unless user_allowed_to_create_event?

    save_and_render_json
  end


  private

  # def club
  #   return {} if current_user.clubs.pluck(:id).exclude? params[:id].to_i
    
  #   Club.find(params[:id])
  # end

  def user_allowed_to_create_event?
    roles = Member.find_by(club_id: params[:club_id], user_id: current_user.id)&.roles || []
    roles.include?(Role.president) || roles.include?(Role.coach)
  end

  def creation_params
    prms = params.require(:event).permit(:name, :start_date)
    prms[:club_id] = params[:club_id]
    prms[:start_date] = Time.at(prms[:start_date].to_i)
    prms
  end
end