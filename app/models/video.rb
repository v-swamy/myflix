class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("lower(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
  end

  def avg_rating
    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    (total.to_f/self.reviews.count.to_f).round(1)
  end
  
end