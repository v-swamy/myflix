require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user, leader: user2)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end  
  end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 9 }
    end

    it "redirects to the people page" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user, leader: user2)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship is current user is the follower" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user, leader: user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      user3 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user3, leader: user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 3 }
    end
    it "redirects to the people path" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      post :create, leader_id: user2.id
      expect(response).to redirect_to people_path
    end
    it "creates the new relationship between current user and selected user" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(1)
    end
    it "sets the leader as the selected user" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      post :create, leader_id: user2.id
      expect(user.following_relationships.first.leader).to eq(user2)
    end
    it "sets the follower as the the current user" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      post :create, leader_id: user2.id
      expect(user.following_relationships.first.follower).to eq(user)
    end
    it "does not create a relationship if the current user already follows the leader" do
      user = Fabricate(:user)
      set_current_user(user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader: user2, follower: user)
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(1)
    end
    it "does not allow a user to follow themselves" do
      user = Fabricate(:user)
      set_current_user(user)
      post :create, leader_id: user.id
      expect(Relationship.count).to eq(0)
    end
  end
end