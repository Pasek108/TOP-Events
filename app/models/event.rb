class Event < ApplicationRecord
  has_many :user_events, dependent: :destroy

  has_many :user_events_attendees, -> { attendees }, class_name: "UserEvent"
  has_many :attendees, through: :user_events_attendees, source: :user

  has_many :user_events_organizers, -> { organizers }, class_name: "UserEvent"
  has_many :organizers, through: :user_events_organizers, source: :user

  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true
end
