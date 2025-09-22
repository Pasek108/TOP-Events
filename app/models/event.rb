class Event < ApplicationRecord
  has_many :user_events, dependent: :destroy

  has_many :user_events_attendees, -> { attendees }, class_name: "UserEvent"
  has_many :attendees, through: :user_events_attendees, source: :user

  has_many :user_events_organizers, -> { organizers }, class_name: "UserEvent"
  has_many :organizers, through: :user_events_organizers, source: :user

  validates :title, presence: true
  validates :date, presence: true
  validates :ending_date, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :location_name, presence: true
  validates :visibility, presence: true

  enum :visibility, { public_event: 0, private_event: 1 }, default: :public_event

  scope :past, -> { where("ending_date < ?", Time.current) }
  scope :ongoing, -> { where("date <= ? AND ending_date >= ?", Time.current, Time.current) }
  scope :upcoming, -> { where("date > ?", Time.current) }

  def past?
    ending_date < Time.current
  end

  def ongoing?
    date <= Time.current && ending_date >= Time.current
  end

  def upcoming?
    date > Time.current
  end

  def formatted_date
    date.strftime("%b %d, %Y at %H:%M")
  end

  def formatted_ending_date
    ending_date.strftime("%b %d, %Y at %H:%M")
  end

  def duration
    time_diff = ending_date - date
    formatted_duration(time_diff)
  end

  def starting_for
    return "Ongoing" if ongoing?
    return "Event has ended" if past?

    time_diff = date - Time.current
    formatted_duration(time_diff)
  end

  private

  def formatted_duration(time_diff)
    time_diff_parts = ActiveSupport::Duration.build(time_diff.to_i).parts.except(:seconds)
    time_diff_parts.map { |key, value| "#{value} #{key.to_s.pluralize(value)}" }.join(" ")
  end
end
