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
end
