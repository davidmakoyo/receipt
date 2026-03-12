require "test_helper"

class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_receipt = receipts(:two)
    @receipt = receipts(:one)
    @user_receipt_two = Receipt.create!(
      user: @user,
      merchant: "Amazon",
      amount: 120.50,
      purchase_date: Date.current - 10.days,
      category: "Shopping",
      notes: "Office supplies"
    )
    @user_receipt_three = Receipt.create!(
      user: @user,
      merchant: "Walmart",
      amount: 15.00,
      purchase_date: Date.current - 1.day,
      category: "Groceries",
      notes: "Snacks"
    )
  end

  test "redirects unauthenticated users from index" do
    get receipts_url
    assert_redirected_to new_user_session_url
  end

  test "shows only current user receipts on index" do
    sign_in @user

    get receipts_url

    assert_response :success
    assert_match @receipt.merchant, @response.body
    assert_no_match @other_receipt.merchant, @response.body
  end

  test "creates receipt for current user" do
    sign_in @user

    assert_difference("Receipt.count", 1) do
      post receipts_url, params: {
        receipt: {
          merchant: "Trader Joe's",
          amount: "25.40",
          purchase_date: Date.current,
          category: "Groceries",
          notes: "Snacks"
        }
      }
    end

    assert_redirected_to receipt_url(Receipt.order(:created_at).last)
  end

  test "updates receipt" do
    sign_in @user

    patch receipt_url(@receipt), params: {
      receipt: { merchant: "Updated Merchant" }
    }

    assert_redirected_to receipt_url(@receipt)
    assert_equal "Updated Merchant", @receipt.reload.merchant
  end

  test "destroys receipt" do
    sign_in @user

    assert_difference("Receipt.count", -1) do
      delete receipt_url(@receipt)
    end

    assert_redirected_to receipts_url
  end

  test "cannot access another users receipt" do
    sign_in @user

    get receipt_url(@other_receipt)
    assert_response :not_found
  end

  test "filters receipts by merchant" do
    sign_in @user

    get receipts_url, params: { merchant: "ama" }

    assert_response :success
    assert_match @user_receipt_two.merchant, @response.body
    assert_no_match @receipt.merchant, @response.body
    assert_no_match @user_receipt_three.merchant, @response.body
  end

  test "filters receipts by date range" do
    sign_in @user

    get receipts_url, params: {
      start_date: (Date.current - 2.days).to_s,
      end_date: Date.current.to_s
    }

    assert_response :success
    assert_match @receipt.merchant, @response.body
    assert_match @user_receipt_three.merchant, @response.body
    assert_no_match @user_receipt_two.merchant, @response.body
  end

  test "filters receipts by amount range" do
    sign_in @user

    get receipts_url, params: { min_amount: "20", max_amount: "60" }

    assert_response :success
    assert_match @receipt.merchant, @response.body
    assert_no_match @user_receipt_two.merchant, @response.body
    assert_no_match @user_receipt_three.merchant, @response.body
  end

  test "exports selected receipts as claim report pdf" do
    sign_in @user

    get claim_report_receipts_url(format: :pdf), params: {
      receipt_ids: [ @receipt.id, @user_receipt_three.id ]
    }

    assert_response :success
    assert_includes @response.media_type, "application/pdf"
    assert_includes @response.body, "%PDF"
  end

  test "claim report ignores receipts not owned by current user" do
    sign_in @user

    get claim_report_receipts_url(format: :pdf), params: {
      receipt_ids: [ @other_receipt.id ]
    }

    assert_redirected_to receipts_url
  end
end
