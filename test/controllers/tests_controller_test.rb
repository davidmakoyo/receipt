require "test_helper"

class TestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:one)
    get tests_path
    assert_response :success
  end

  test "should get show" do
    sign_in users(:one)
    get test_path(supported_tests(:one).slug)
    assert_response :success
  end
end
