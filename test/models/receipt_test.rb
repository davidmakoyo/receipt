require "test_helper"

class ReceiptTest < ActiveSupport::TestCase
  test "valid fixture is valid" do
    assert receipts(:one).valid?
  end

  test "requires merchant" do
    receipt = receipts(:one).dup
    receipt.merchant = nil

    assert_not receipt.valid?
    assert_includes receipt.errors[:merchant], "can't be blank"
  end

  test "requires non negative amount" do
    receipt = receipts(:one).dup
    receipt.amount = -1

    assert_not receipt.valid?
    assert_includes receipt.errors[:amount], "must be greater than or equal to 0"
  end

  test "this_month returns only receipts within current month" do
    assert_includes Receipt.this_month, receipts(:one)
    assert_not_includes Receipt.this_month, receipts(:two)
  end

  test "by_category returns summed totals" do
    totals = Receipt.by_category

    assert_equal BigDecimal("42.55"), totals["Groceries"]
    assert_equal BigDecimal("14.2"), totals["Dining"]
  end
end
