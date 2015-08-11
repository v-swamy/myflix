require 'spec_helper'

feature "Admin sees payments" do
  background do
    user = Fabricate(:user, name: "John Smith", email: "john@nowhere.com")
    Fabricate(:payment, amount: 999, user: user)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("john@nowhere.com")
    expect(page).to have_content("John Smith")
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("john@nowhere.com")
    expect(page).not_to have_content("John Smith")
    expect(page).to have_content("You are not permitted to do that.")
  end
end