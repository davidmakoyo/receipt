require "test_helper"

class TestResultsControllerTest < ActionDispatch::IntegrationTest
  test "should create or update result" do
    sign_in users(:one)
    post test_results_path(supported_tests(:one).slug), params: { test_result: { result_value: "Lion" } }
    assert_redirected_to test_path(supported_tests(:one).slug)
  end
end
