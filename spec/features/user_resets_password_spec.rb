require 'spec_helper'

feature "User resets password" do
  scenario "user successfully resets the password" do
    user = Fabricate(:user, password: 'old_password')

    visit sign_in_path
    click_link "Forgot password?"
    fill_in 'Email Address', with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link "Reset My Password"

    fill_in 'New Password', with: "new_password"
    click_button "Reset Password"

    expect(page).to have_content("Your password has been changed. Please sign in.")

    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: "new_password"
    click_button "Sign in"

    expect(page).to have_content("Welcome, #{user.name}")  

    clear_email  
  end
end