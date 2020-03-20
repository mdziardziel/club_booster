module ClubMember
  extend ActiveSupport::Concern

  private

  def club_member
    @club_member ||= 
      Member.find_by(user_id: current_user.id, club_id: club.id, approved: true)
  end

  def club
    @club ||= Club.find(params[:club_id])
  end
end