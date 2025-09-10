class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :role, { organizer: 0, attendee: 1, performer: 2 }
  validates :role, presence: true

  scope :organizers, -> { where(role: :organizer) }
  scope :attendees, -> { where(role: :attendee) }
  scope :performers, -> { where(role: :performer) }
end
