class PostsController < ApplicationController
  before_action :signed_in_user

  def create
    @post = Post.new(params[:post])
    @post.save
    redirect_to @current_user
    end
  end

  def destroy

  end
end