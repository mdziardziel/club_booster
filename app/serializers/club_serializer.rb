class ClubSerializer < ActiveModel::Serializer
  attributes :id, :name, :token, :logo_url, :member_roles

  def logo_url
    return nil if object.logo_url.blank?

    DROPBOX_CLIENT.get_temporary_link "/dropbox/#{object.logo_url}"
  rescue
    nil
  end


  def member_roles
    object.try(:member_roles) ||
      Member.find_by(club_id: object.id, user_id: instance_options[:current_user].id).roles
  end
end
