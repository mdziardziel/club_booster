class GroupsController < ApiAuthorizedController
  include ClubMember
  include CreationHelper

  before_action :authorize_only_club_members
  before_action :authorize_only_president_or_coach_role, only: %i(create)

  def create
    save_and_render_json
  end

  private

  def creation_params
    prms = params.require(:group).permit(:name, :members_ids)
    prms[:club_id] = params[:club_id]
    prms[:members_ids] = Member.where(id: prms[:members_ids], club_id: params[:club_id]).pluck(:id)
    prms
  end
end