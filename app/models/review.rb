class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :rating, :body
  validates_numericality_of :rating, only_integer: :true,
    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5
  # validates_uniqueness_of :user_id, scope: :video_id
end