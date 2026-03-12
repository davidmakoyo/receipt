class DashboardController < ApplicationController
  def show
    this_month_receipts = current_user.receipts.this_month

    @receipt_count = this_month_receipts.count
    @this_month_total = this_month_receipts.sum(:amount)
    @category_totals = this_month_receipts.by_category
    @recent_receipts = current_user.receipts.recent.limit(8)
  end
end
