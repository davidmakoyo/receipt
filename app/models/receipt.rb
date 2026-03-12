class Receipt < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :merchant, :amount, :purchase_date, :category, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(purchase_date: :desc, created_at: :desc) }
  scope :this_month, lambda {
    where(purchase_date: Time.current.beginning_of_month.to_date..Time.current.end_of_month.to_date)
  }
  scope :by_category, -> { group(:category).sum(:amount) }
end
