class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(params.require(:review).permit(:rating, :body))
    @review.user = current_user

    if @review.save
      flash[:success] = "Your review has been saved."
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end
  
end