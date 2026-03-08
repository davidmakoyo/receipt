class TestResultsController < ApplicationController
  def create
    test = SupportedTest.find_by(slug: params[:slug])
    return redirect_to tests_path, alert: "Test not found." if test.blank?

    result = current_user.test_results.find_or_initialize_by(supported_test: test)
    result.result_value = test_result_params[:result_value]

    if result.save
      redirect_to test_path(test.slug), notice: "Result saved successfully."
    else
      redirect_to test_path(test.slug), alert: result.errors.full_messages.to_sentence
    end
  end

  private

  def test_result_params
    params.require(:test_result).permit(:result_value)
  end
end
