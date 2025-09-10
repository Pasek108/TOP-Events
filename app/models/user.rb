class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true

  has_many :user_events, dependent: :destroy

  def attended_events
    user_events.attendees.map(&:event)
  end

  def organized_events
    user_events.organizers.map(&:event)
  end

  def performed_events
    user_events.performers.map(&:event)
  end
end
