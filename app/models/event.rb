class Event < ApplicationRecord
  has_many :user_events, dependent: :destroy

  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true

  def attendees
    user_events.attendees.map(&:user)
  end

  def organizers
    user_events.organizers.map(&:user)
  end

  def performers
    user_events.performers.map(&:user)
  end
end
