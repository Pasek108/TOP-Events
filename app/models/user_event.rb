class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :role, presence: true

  enum :role, { organizer: 0, attendee: 1 }

  scope :organizers, -> { where(role: :organizer) }
  scope :attendees, -> { where(role: :attendee) }
end
