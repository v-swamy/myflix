require 'spec_helper'

feature "User adds new video" do
  scenario "Admin succesfully adds a new video" do
    
    admin = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Lost"
    select "Dramas", from: "Category"
    fill_in "Description", with: "Crazy island plane crash stuff."
    attach_file "Large cover", "spec/support/uploads/lost_large.jpg"
    attach_file "Small cover", "spec/support/uploads/lost_small.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/lost_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end
end