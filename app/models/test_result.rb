class TestResult < ApplicationRecord
  belongs_to :user
  belongs_to :supported_test

  validates :result_value, presence: true
  validates :supported_test_id, uniqueness: { scope: :user_id }
end
