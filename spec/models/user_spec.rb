require 'spec_helper'
require 'shoulda/matchers'

describe User do
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_secure_password }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(5) }
  it { should have_many(:queue_items).order(:position) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#queued_video?" do
    it "returns true when the video is in the user's queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end
    it "returns false when the video is not in the user's queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be false
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      user = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader: user2, follower: user)
      expect(user.follows?(user2)).to be_true
    end
    it "returns false if the user does not have a following relationship with another user" do
      user = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader: user, follower: user2)
      expect(user.follows?(user2)).to be_false
    end
  end

  describe "#follow" do
    it "follows another user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user1.follow(user2)
      expect(user1.follows?(user2)).to be_true
    end
    it "does not follow oneself" do
      user1 = Fabricate(:user)
      user1.follow(user1)
      expect(user1.follows?(user1)).to be_false
    end
  end

  describe "#deactivate!" do
    it "deactivates the active user" do
      user = Fabricate(:user, active: true)
      user.deactivate!
      expect(user).not_to be_active
    end
  end
end