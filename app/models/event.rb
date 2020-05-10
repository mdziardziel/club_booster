class Event < ApplicationRecord
  SYMBOLS = %w(T M).freeze

  belongs_to :club, inverse_of: :events

  validates :club_id, presence: { message: trans('errors.messages.blank', :male) }
  validates :name, presence: { message: trans('errors.messages.blank', :neuter) }
  validates :start_date, presence: { message: trans('errors.messages.blank', :female) }
  validates :symbol, presence: { message: trans('errors.messages.blank', :male) }
  validates :symbol, inclusion: { in: SYMBOLS, message: trans('errors.messages.inclusion', :male) } 

  validate :start_before_end


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

  private

  def start_before_end
    return if start_date.nil? || end_date.nil?
    return if start_date < end_date

    errors.add(:end_date, trans('activerecord.errors.event.end_date_before_start_date', :female))
    errors.add(:start_date, trans('activerecord.errors.event.start_date_after_end_date', :female))
  end
end
