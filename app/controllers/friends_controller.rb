class FriendsController < ApplicationController
  def index
    @friendships = current_user.friendships.includes(:friend).order(created_at: :asc)
  end

  def create
    username = params[:username].to_s.strip.downcase
    friend = User.find_by(username: username)
    return redirect_to friends_path, alert: "User not found." if friend.blank?

    if friend == current_user
      return redirect_to friends_path, alert: "You cannot add yourself as a friend."
    end

    ApplicationRecord.transaction do
      current_user.friendships.find_or_create_by!(friend: friend)
      friend.friendships.find_or_create_by!(friend: current_user)
    end

    redirect_to friends_path, notice: "#{friend.username} is now your friend."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to friends_path, alert: e.record.errors.full_messages.to_sentence
  end

  def destroy
    friendship = current_user.friendships.find(params[:id])
    friend = friendship.friend

    ApplicationRecord.transaction do
      friendship.destroy!
      friend.friendships.find_by(friend: current_user)&.destroy!
    end

    redirect_to friends_path, notice: "#{friend.username} removed from your friends."
  end
end
