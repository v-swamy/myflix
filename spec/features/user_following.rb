require 'spec_helper'

feature "User following" do
  scenario "User follows and unfollows another user" do
    user1 = Fabricate(:user)
    user2 = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, video: video, user: user2)

    sign_in(user1)
    visit home_path
    click_on_video_on_home_page(video)
    
    click_link "by #{user2.name}"
    click_link "Follow"

    expect(page).to have_content("People I Follow")
    expect(page).to have_content(user2.name)

    unfollow(user2)
    expect(page).not_to have_content(user2.name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end

end
