class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.reviews.count != 0 ? "#{object.avg_rating}" : "N/A"
  end
end
