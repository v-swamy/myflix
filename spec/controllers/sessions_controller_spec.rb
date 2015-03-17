require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template(:new)
    end

    it "redirects to home path if user is logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do

      it "puts signed in user in the session" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the home path" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to home_path
      end

      it "sets the success flash message" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password + 'asdf'
      end

      it "does not put the signed in user in the session" do
        expect(session[:user_id]).to be_nil
      end
      
      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the danger flash message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get "destroy"
    end

    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the warning flash message" do
      expect(flash[:warning]).not_to be_blank
    end

  end
end