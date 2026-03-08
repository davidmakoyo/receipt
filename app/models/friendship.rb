class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :friend_id, uniqueness: { scope: :user_id }
  validate :cannot_friend_self

  private

  def cannot_friend_self
    return unless user_id == friend_id

    errors.add(:friend_id, "can't be the same as user")
  end
end
