module EventsHelper
  def joined_event?(event)
    event.attendees.include?(current_user)
  end
end
