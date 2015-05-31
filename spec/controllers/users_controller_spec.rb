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

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to sign in path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        user1 = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user1)
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
        user2 = User.where(email: invitation.recipient_email).first
        expect(user2.follows?(user1)).to be_true
      end

      it "makes the inviter follow the user" do
        user1 = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user1)
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
        user2 = User.where(email: invitation.recipient_email).first
        expect(user1.follows?(user2)).to be_true
      end

      it "expires the invitation upon acceptance" do
        user1 = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user1)
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
        user2 = User.where(email: invitation.recipient_email).first
        expect(Invitation.first.token).to be_nil
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

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'invalid'
      expect(response).to redirect_to expired_token_path
    end
  end
end

