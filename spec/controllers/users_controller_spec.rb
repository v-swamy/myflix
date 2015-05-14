require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    context "with valid input" do

      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do

      before do 
        post :create, user: {name: "Tom Smith"}
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "email sending" do

      after { ActionMailer::Base.deliveries.clear }

      it "sends the email to the user with valid inputs" do
        post :create, user: Fabricate.attributes_for(:user, email: "vik@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["vik@example.com"])
      end

      it "sends out an email containing the user's name with valid inputs" do
        post :create, user: Fabricate.attributes_for(:user, name: "Vik Swamy")
        expect(ActionMailer::Base.deliveries.last.body).to include("Vik Swamy")
      end

      it "does not send out email with invalid inputs" do
        post :create, user: {name: "Vik Swamy"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets the @user variable" do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end
end

