class Event < ApplicationRecord
  belongs_to :club, inverse_of: :events

  validates :club_id, presence: { message: I18nForPerson.t('errors.messages.blank', :male) }
  validates :name, presence: { message: I18nForPerson.t('errors.messages.blank', :neuter) }
  validates :start_date, presence: { message: I18nForPerson.t('errors.messages.blank', :female) }


  def check_presence(member_id, status)
    status = false if ['0', 0, 'false', 'False', 'FALSE'].include?(status)
    status = true if ['1', 1, 'true', 'True', 'TRUE'].include?(status)
    status_b = !!status
    member_id_s = member_id.to_s
    return if participants_ids.exclude?(member_id_s)

    self.participants[member_id_s] = status_b
    save
    participants[member_id_s] == status_b
  end

  def participants_ids
    participants.keys
  end
end
