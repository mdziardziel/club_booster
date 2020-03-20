class ClubsController < ApiAuthorizedController
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

  private

  def club
    @club ||= member.club
  end

  def member
    @member ||= Member.find_by(user_id: current_user.id, club_id: params[:id])
  end

  def creation_params
    params.require(:club).permit(:name).merge(owner_id: current_user.id)
  end
end