class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("lower(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
  end
end