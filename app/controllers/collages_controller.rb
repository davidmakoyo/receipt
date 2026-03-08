class CollagesController < ApplicationController
  def show
    @user = params[:username].present? ? User.find_by(username: params[:username]) : current_user
    return redirect_to my_collage_path, alert: "User not found." if @user.blank?

    if @user != current_user && !current_user.friends_with?(@user)
      return redirect_to friends_path, alert: "You can only view collages of your friends."
    end

    @supported_tests = SupportedTest.order(:name)
    @result_map = @user.test_results.includes(:supported_test).index_by(&:supported_test_id)
  end
end
