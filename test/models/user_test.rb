require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes username before validation" do
    user = User.new(
      email: "new@example.com",
      username: "  NewUser  ",
      password: "password123",
      password_confirmation: "password123"
    )

    user.valid?
    assert_equal "newuser", user.username
  end
end
