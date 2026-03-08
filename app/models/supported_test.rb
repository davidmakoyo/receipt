class SupportedTest < ApplicationRecord
  has_many :test_results, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
