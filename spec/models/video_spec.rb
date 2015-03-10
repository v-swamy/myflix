require 'spec_helper'
require 'shoulda/matchers'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe ".search_by_title" do
    it "returns empty array if no matches" do
      video1 = Video.create(title: "Die Hard", description: "Action movie.")
      video2 = Video.create(title: "Die Hard 2", description: "Action movie again.")
      expect(Video.search_by_title("star")).to eq([])
    end

    it "returns an array with one video for exact match" do
      video1 = Video.create(title: "Star Wars", description: "Use the force!")
      video2 = Video.create(title: "Die Hard 2", description: "Action movie again.")
      expect(Video.search_by_title("Star Wars")).to eq([video1])
    end

    it "returns an array with one video for partial match" do
      video1 = Video.create(title: "Star Wars", description: "Space cartoon.")
      video2 = Video.create(title: "Die Hard 2", description: "Action movie again.")
      expect(Video.search_by_title("War")).to eq([video1])
    end

    it "returns an array of multiple matches ordered by created_at" do
      video1 = Video.create(title: "Star Wars", description: "Use the force!", created_at: 1.day.ago)
      video2 = Video.create(title: "Star Wars 2", description: "Emperor Strikes Back!")
      expect(Video.search_by_title("War")).to eq([video2, video1])
    end

    it "returns an array of one video for exact lowercase match" do
      video1 = Video.create(title: "Star Wars", description: "Use the force!")
      video2 = Video.create(title: "Die Hard 2", description: "Action movie again.")
      expect(Video.search_by_title("star wars")).to eq([video1])
    end

    it "returns an array of multiple matches ordered by created_at for lowercase match" do
      video1 = Video.create(title: "Star Wars", description: "Use the force!", created_at: 1.day.ago)
      video2 = Video.create(title: "Star Wars 2", description: "Emperor Strikes Back!")
      expect(Video.search_by_title("ar wa")).to eq([video2, video1])
    end

    it "returns an empty array for a search with an empty string" do
      video1 = Video.create(title: "Star Wars", description: "Use the force!")
      video2 = Video.create(title: "Die Hard 2", description: "Action movie again.")
      expect(Video.search_by_title("")).to eq([])
    end
    
  end
end
