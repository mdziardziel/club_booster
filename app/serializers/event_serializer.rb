class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :end_date, :participants, :club_id, :end_date, :symbol, :color, :start, :end, :title, :description

  def start
    object.start_date
  end

  def end
    object.end_date
  end

  def title
    object.name
  end
end
