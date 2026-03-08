require "test_helper"

class CollagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    sign_in users(:one)
    get my_collage_path
    assert_response :success
  end
end
