require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save event without title" do
    event = Event.new(date: DateTime.current, location: "52, 19")
    assert_not event.save, "Saved the event without title"
  end

  test "should not save event without date" do
    event = Event.new(title: "Test title", location: "52, 19")
    assert_not event.save, "Saved the event without date"
  end

  test "should not save event without location" do
    event = Event.new(title: "Test title", date: DateTime.current)
    assert_not event.save, "Saved the event without location"
  end

  test "should save valid event" do
    event = Event.new(title: "Test title", date: DateTime.current, location: "52, 19")
    assert event.save, "Couldn't save a valid event"
  end

  test "attendees should return correct users" do
    event = events(:two)
    expected_attendees = [ users(:one) ]
    assert_equal expected_attendees, event.attendees, "Attendees method did not return the correct users"
  end

  test "organizers should return correct users" do
    event = events(:one)
    expected_organizers = [ users(:one) ]
    assert_equal expected_organizers, event.organizers, "Organizers method did not return the correct users"
  end

  # test "performers should return correct users" do
  #   event = events(:two)
  #   expected_performers = []
  #   assert_equal expected_performers, event.performers, "Performers method did not return the correct users"
  # end

  test "deleting event should delete associated user_events" do
    event = events(:one)

    assert_difference("UserEvent.count", -1) do
      event.destroy
    end
  end
end
