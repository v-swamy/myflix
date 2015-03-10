require 'spec_helper'
require 'shoulda/matchers'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "should return most recent videos first" do
      cool_videos = Category.create(name: "Cool Videos")
      video1 = Video.create(title: "Video 1", description: "Created yesterday", category: cool_videos, created_at: 1.day.ago)
      video2 = Video.create(title: "Video 2", description: "Created today", category: cool_videos)
      expect(cool_videos.recent_videos).to eq([video2, video1])
    end

    it "should return most recent six videos, most recent first" do
      cool_videos = Category.create(name: "Cool Videos")
      10.times do |i|
        Video.create(title: "Video #{i+1}", description: "Cool Video #{i+1}", category: cool_videos, created_at: (10-i).day.ago)
      end
      videos = Video.all.sort_by {|vid| vid[:created_at]}.reverse
      expect(cool_videos.recent_videos).to eq(videos.first(6))
    end
    
    it "should return fewer than six videos if total videos is fewer than six" do
      cool_videos = Category.create(name: "Cool Videos")
      4.times do |i|
        Video.create(title: "Video #{i+1}", description: "Cool Video #{i+1}", category: cool_videos, created_at: (10-i).day.ago)
      end
      expect(cool_videos.recent_videos.count).to eq(4)
    end

    it "should return empty array if no videos" do
      cool_videos = Category.create(name: "Cool Videos")
      10.times do |i|
        Video.create(title: "Video #{i+1}", description: "Cool Video #{i+1}", created_at: (10-i).day.ago)
      end
      expect(cool_videos.recent_videos).to eq([])
    end
  end
end
