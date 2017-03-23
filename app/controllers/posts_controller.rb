class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :owned_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.of_followed_users(current_user.following).order(created_at: :desc).page params[:page]
  end

  def browse
    @posts = Post.all.page params[:page]
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to root_path
    else
      flash.now[:alert] = "Your new post couldn't be created! Please check the form."
      render :new
    end
  end

  def edit
  end

  def update
    @post.update(post_params)
    if @post.save
      flash[:success] = "Post updated."
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "Update failed. Please check the form."
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  def like
    debugger
    if @post.liked_by current_user
      create_notification @post, @post.user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def unlike
    if @post.unliked_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :caption)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def owned_post
    unless current_user == @post.user
      flash[:alert] = "That post doesn't belong to you !"
      redirect_to root_path
    end
  end

  def create_notification(post, user)
    return if post.user.id == current_user.id
    Notification.create(user_id: user.id,
                        notified_by_id: current_user.id,
                        post_id: post.id,
                        identifier: user.id,
                        notice_type: 'like')
  end
end
