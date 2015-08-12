require 'spec_helper'

feature "User signs in" do
  scenario "with valid credentials" do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content(user.name)
  end

  scenario "with deactivated user" do
    user = Fabricate(:user, active: false)
    sign_in(user)
    expect(page).not_to have_content(user.name)
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end