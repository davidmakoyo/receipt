demo_user = User.find_or_initialize_by(email: "demo@receiptrescue.app")
demo_user.username = "demo"
demo_user.password = "password123"
demo_user.password_confirmation = "password123"
demo_user.save!

sample_receipts = [
  { merchant: "Whole Foods", amount: 62.14, purchase_date: Date.current - 4.days, category: "Groceries", notes: "Weekly groceries" },
  { merchant: "Uber", amount: 18.90, purchase_date: Date.current - 3.days, category: "Transport", notes: "Airport ride" },
  { merchant: "Target", amount: 47.55, purchase_date: Date.current - 2.days, category: "Shopping", notes: "Household supplies" },
  { merchant: "Chipotle", amount: 13.27, purchase_date: Date.current - 1.day, category: "Dining", notes: "Lunch" }
]

sample_receipts.each do |attrs|
  receipt = demo_user.receipts.find_or_initialize_by(
    merchant: attrs[:merchant],
    purchase_date: attrs[:purchase_date]
  )
  receipt.update!(attrs)
end
