require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do

    it "sets @queue_items to the queue items of signed in user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do

    let(:video) { Fabricate(:video) }

    context "for authenticated users" do

      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }

      it "redirects to the my_queue page" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates a new queue item" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a new queue item associated with the video" do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates a new queue item associated with the signed in user" do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end

      it "adds the queue item to the bottom of the queue for the logged in user" do
        Fabricate(:queue_item, video: video, user: user)
        video2 = Fabricate(:video)
        post :create, video_id: video2.id
        video2_queue_item = QueueItem.where(video_id: video2.id, user_id: user.id).first
        expect(video2_queue_item.position).to eq(2)
      end

      it "does not add the video to the queue if the video is already in queue" do
        Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(user.queue_items.count).to eq(1)
      end
    end

    context "for unauthenticated users" do

      it "redirects to the sign in page for unauthenticated users" do
        post :create, video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do

    let(:user) { Fabricate(:user) }

    context "for authenticated users" do

      before { session[:user_id] = user.id }

      it "redirects to the my_queue page" do
        Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item2.id
        expect(response).to redirect_to my_queue_path
      end
      
      it "deletes the queue_item from the logged in user's queue " do
        Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item2.id
        expect(user.queue_items.count).to eq(1)
      end

      it "normalizes the remaining queue items" do
        queue_item1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.position).to eq(1)
      end

      it "does not delete the queue item if not in current user's queue" do
        user2 = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "for unauthenticated users" do

      it "redirects to the sign in page for unauthenticated users" do
        delete :destroy, id: 1
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do

      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate (:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2, video: video) }

      before { session[:user_id] = user.id }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(user.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do

      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate (:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2, video: video) }

      before { session[:user_id] = user.id }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path      
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:danger]).to be_present     
      end

      it "does not change the queue items" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
          expect(queue_item1.reload.position).to eq(1)   
      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 3, position: 4}]
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with queue items that do not belong to current user" do
      it "does not change the queue items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        user2 = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user2, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end