require 'spec_helper'

describe VideoDecorator do
  describe "#rating" do
    it "returns N/A if no reviews present" do
      video = Fabricate(:video)
      video_decorator = VideoDecorator.decorate(video)
      expect(video_decorator.rating).to eq("N/A")
    end

    it "returns the average rating of the video if reviews present" do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 3, user: Fabricate(:user))
      Fabricate(:review, video: video, rating: 4, user: Fabricate(:user))
      video_decorator = VideoDecorator.decorate(video)
      expect(video_decorator.rating).to eq("3.5")
    end
  end
end
