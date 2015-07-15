require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).
          sign_up(stripe_token: "some_stripe_token")
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        user1 = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user1)
        UserSignup.new(Fabricate.build(:user, email: invitation.recipient_email)).sign_up(
          stripe_token: "some_stripe_token", 
          invitation_token: invitation.token
        )
        user2 = User.find_by(email: invitation.recipient_email)
        expect(user2.follows?(user1)).to be_true
      end

      it "makes the inviter follow the user" do
        user1 = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user1)
        UserSignup.new(Fabricate.build(:user, email: invitation.recipient_email)).sign_up(
          stripe_token: "some_stripe_token", 
          invitation_token: invitation.token
        )
        user2 = User.find_by(email: invitation.recipient_email)
        expect(user1.follows?(user2)).to be_true
      end

      it "expires the invitation upon acceptance" do
        user1 = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user1)
        UserSignup.new(Fabricate.build(:user, email: invitation.recipient_email)).sign_up(
          stripe_token: "some_stripe_token", 
          invitation_token: invitation.token
        )
        expect(Invitation.first.token).to be_nil
      end

      it "sends the email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "vik@example.com")).
          sign_up(stripe_token: "some_stripe_token")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["vik@example.com"])
      end

      it "sends out an email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, name: "Vik Swamy")).
          sign_up(stripe_token: "some_stripe_token")
        expect(ActionMailer::Base.deliveries.last.body).to include("Vik Swamy")
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, 
          error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).
          sign_up(stripe_token: "some_stripe_token")
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        UserSignup.new(User.new(name: "Tom Smith")).sign_up(stripe_token: 
          "some_stripe_token")
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(name: "Tom Smith")).
          sign_up(stripe_token: "some_stripe_token")
      end

      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(name: "Tom Smith")).
          sign_up(stripe_token: "some_stripe_token")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
