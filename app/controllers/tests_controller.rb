class TestsController < ApplicationController
  def index
    @tests = SupportedTest.order(:name)
  end

  def show
    @test = SupportedTest.find_by(slug: params[:slug])
    return redirect_to tests_path, alert: "Test not found." if @test.blank?

    @test_result = current_user.test_results.find_by(supported_test: @test) || current_user.test_results.new
  end
end
