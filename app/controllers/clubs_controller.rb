class ClubsController < ApiAuthorizedController
  include ClubMember
  include CreationHelper
  
  before_action :authorize_only_club_members, only: %i(show update)
  before_action :authorize_only_president_or_coach_role, only: %i(update)

  def index
    clubs = Member.select('clubs.*', 'members.roles as member_roles').where(user_id: current_user.id).joins(:club)
    render json: clubs, each_serializer: ClubSerializer, current_user: current_user
  end

  def show
    club.assign_s3_presigned_url if club_member.has_president_role? || club_member.has_coach_role?
    render json: club, serializer: ClubSerializer, current_user: current_user
  end

  def create
    save_and_render_json
  end

  def update
    update_and_render_json
  end

  def leave
    member = Member.find_by(user_id: current_user.id, club_id: club.id)
    if member.present?
      member.destroy
      respond_with member, { method: :delete }
    else
      render json: {}, status: 404
    end
  end

  private

  def club
    @club ||= Club.find(params[:id])
  end

  def creation_params
    params.require(:club).permit(:name).merge(owner_id: current_user.id)
  end

  def update_params
    params.require(:club).permit(:name, :logo_url)
  end
end