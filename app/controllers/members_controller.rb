class MembersController < ApiAuthorizedController
  include ClubMember
  include CreationHelper

  before_action :authorize_only_club_members
  before_action :authorize_only_president_or_coach_role, only: %i(approve)
  before_action :authorize_only_proper_club_tokens, only: %i(create)

  def create
    save_and_render_json
  end

  def approve

  end

  private

  def creation_params
    prms = params.require(:member).permit(:name)
    prms[:club_id] = params[:club_id]
    prms[:user_id] = current_user.id
    prms
  end

  def proper_club_token_provided
    raise NotAuthorizedError if club_with_proper_token.blank?
  end

  def club_with_proper_token
    @club_with_proper_token ||= 
      Club.find_by(id: params[:club_id], token: params[:club_token])
  end
end