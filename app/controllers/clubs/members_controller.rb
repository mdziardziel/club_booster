module Clubs
  class MembersController < ApiAuthorizedController
    include ClubMember
    include CreationHelper
  
    before_action :authorize_only_club_members, except: %i(create)
    before_action :authorize_only_president_or_coach_role, only: %i(approve)
    before_action :authorize_only_proper_club_tokens, only: %i(create)
  
    def create
      save_and_render_json
    end

    def update
      update_and_render_json
    end
  
    def approve
      member = Member.find(params[:member_id])&.update(approve_params)
      if member
        render json: { message: 'Member approved', data: member, errors: {}}, status: 201
      else
        render json: { message: 'Member not approved', data: member, errors: member.errors.messages }, status: 422
      end  
    end
  
    private
  
    def approve_params
      params.require(:member).permit(roles: []).merge(approved: true)
    end
  
    def creation_params
      {
        club_id: params[:club_id],
        user_id: current_user.id
      }
    end
  
    def authorize_only_proper_club_tokens
      raise NotAuthorizedError if club_with_proper_token.blank?
    end
  
    def club_with_proper_token
      @club_with_proper_token ||= 
        Club.find_by(id: params[:club_id], token: params[:club_token])
    end
  end
end