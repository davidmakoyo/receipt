require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users" do
    get dashboard_url
    assert_redirected_to new_user_session_url
  end

  test "renders dashboard for signed in user" do
    sign_in users(:one)

    get dashboard_url

    assert_response :success
    assert_select "h1", text: "Spending Overview"
    assert_select "a", text: "Add Receipt"
  end
end
