class ClubsController < ApiAuthorizedController

  def index
    render json: current_user.clubs
  end

  def show
    render json: club
  end

  def create
    save_and_render_json
  end

  private

  def club
    return {} if current_user.clubs.pluck(:id).exclude? params[:id].to_i
    
    Club.find(params[:id])
  end

  def creation_params
    params.require(:club).permit(:name).merge(owner_id: current_user.id)
  end
end