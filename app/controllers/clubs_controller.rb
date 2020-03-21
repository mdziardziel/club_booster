class ClubsController < ApiAuthorizedController
  include ClubMember
  include CreationHelper
  
  before_action :authorize_only_club_members, only: %i(show)

  def index
    render json: current_user.clubs
  end

  def show
    render json: club
  end

  def create
    save_and_render_json
  end

  def update
    update_and_render_json
  end

  private

  def club
    @club ||= Club.find(params[:id])
  end

  def creation_params
    params.require(:club).permit(:name).merge(owner_id: current_user.id)
  end

  def update_params
    params.require(:club).permit(:name)
  end
end