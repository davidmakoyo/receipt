require "test_helper"

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:one)
    get friends_path
    assert_response :success
  end

  test "should create friendship" do
    sign_in users(:one)
    assert_difference("Friendship.count", 2) do
      post friends_path, params: { username: users(:three).username }
    end
  end

  test "should destroy friendship" do
    sign_in users(:one)
    assert_difference("Friendship.count", -2) do
      delete friend_path(friendships(:one))
    end
  end
end
