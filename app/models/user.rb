class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true

  has_many :user_events, dependent: :destroy

  has_many :user_events_attendee, -> { where(role: :attendee) }, class_name: "UserEvent"
  has_many :attended_events, through: :user_events_attendee, source: :event

  has_many :user_events_organizer, -> { where(role: :organizer) }, class_name: "UserEvent"
  has_many :organized_events, through: :user_events_organizer, source: :event
end
