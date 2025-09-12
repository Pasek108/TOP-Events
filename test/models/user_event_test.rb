require "test_helper"

class UserEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save user_event without role" do
    user_event = UserEvent.new(user: users(:one), event: events(:one))
    assert_not user_event.save, "Saved the user_event without role"
  end

  test "should save valid user_event" do
    user_event = UserEvent.new(user: users(:one), event: events(:one), role: :organizer)
    assert user_event.save, "Couldn't save a valid user_event"
  end
end
