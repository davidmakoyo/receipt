class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :receipts, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :normalize_username

  private

  def normalize_username
    self.username = username.to_s.strip.downcase.presence
  end
end
