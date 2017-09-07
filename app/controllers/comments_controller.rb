class CommentsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
   	@comments = Comment.includes(:user).order(:created_at)
    respond_to do |format|
      format.html
      format.json { render :json => @comments }
    end
  end

  def create
    @comment = current_user.comments.create(comment_params)
    respond_to do |format|
      format.json do
        if @comment.save
          render :json => @comment
        else
          render :json => { :errors => @comment.errors.messages }, :status => 422
        end
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.json do
        if @comment.user == current_user
        	@comment.update(comment_params)
          render :json => @comment
        else
          render :json => { :errors => @comment.errors.messages }, :status => 422
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
