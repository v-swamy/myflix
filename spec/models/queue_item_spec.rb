require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position) }

  it { is_expected.to delegate_method(:video_title).to(:video).as(:title) }
  it { is_expected.to delegate_method(:category).to(:video) }
  it { is_expected.to delegate_method(:category_name).to(:category).as(:name) }


  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(4)
    end
    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#=rating" do
    it "changes the rating of the review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 2)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    it "clears the rating of the review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 2)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end
    it "creates a new review with the rating if no review present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

end