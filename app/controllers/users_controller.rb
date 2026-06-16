class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
      .with_attached_photo
      .includes(user: { photo_attachment: :blob }, votes: [], comments: [:user, :votes])
      .order(created_at: :desc)
  end
end
