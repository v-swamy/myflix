require 'spec_helper'

feature "User registers", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "User has valid user info and valid  card" do
    user_fills_in_valid_user_info
    user_fills_in_credit_card_info("4242424242424242")
    click_button "Sign Up"
    expect(page).to have_content("Thank you for registering with MyFlix. Please sign in to continue.")
  end

  scenario "User has valid user info and invalid card" do
    user_fills_in_valid_user_info
    user_fills_in_credit_card_info("000")
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "User has valid user info and declined card" do
    user_fills_in_valid_user_info
    user_fills_in_credit_card_info("4000000000000002")
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end

  scenario "User has invalid user info and valid card" do
    user_fills_in_invalid_user_info
    user_fills_in_credit_card_info("4242424242424242")
    click_button "Sign Up"
    expect(page).to have_content("Invalid user info. Please check the below errors and try again.")
  end

  scenario "User has invalid user info and invalid card" do
    user_fills_in_invalid_user_info
    user_fills_in_credit_card_info("000")
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "User has invalid user info and declined card" do
    user_fills_in_invalid_user_info
    user_fills_in_credit_card_info("4000000000000002")
    click_button "Sign Up"
    expect(page).to have_content("Invalid user info. Please check the below errors and try again.")
  end
end

def user_fills_in_valid_user_info
  fill_in "Email Address", with: "example@no.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "John Smith"
end

def user_fills_in_invalid_user_info
  fill_in "Email Address", with: ""
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "John Smith"
end

def user_fills_in_credit_card_info(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select "2016", from: "date_year"
end