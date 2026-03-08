class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :test_results, dependent: :destroy
  has_many :supported_tests, through: :test_results

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :normalize_username

  def friends_with?(other_user)
    friendships.exists?(friend: other_user)
  end

  private

  def normalize_username
    self.username = username.to_s.strip.downcase.presence
  end
end
