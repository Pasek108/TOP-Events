require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save user without username" do
    user = User.new(email: "mail@mail.com", password: "12345678", password_confirmation: "12345678")
    assert_not user.save, "Saved the user without username"
  end

  test "should not save user without email" do
    user = User.new(username: "user", password: "12345678", password_confirmation: "12345678")
    assert_not user.save, "Saved the user without email"
  end

  test "should not save user without password" do
    user = User.new(username: "user", email: "mail@mail.com", password_confirmation: "12345678")
    assert_not user.save, "Saved the user without password"
  end

  test "should not save user with too short password" do
    user = User.new(username: "user", email: "mail@mail.com", password: "1234", password_confirmation: "1234")
    assert_not user.save, "Saved the user with too short password"
  end

  test "should not save user with diffrent passwords" do
    user = User.new(username: "user", email: "mail@mail.com", password: "12345678", password_confirmation: "87654321")
    assert_not user.save, "Saved the user with diffrent passwords"
  end

  test "should save valid user" do
    user = User.new(username: "user", email: "mail@mail.com", password: "12345678", password_confirmation: "12345678")
    assert user.save, "Couldn't save a valid user"
  end
end
