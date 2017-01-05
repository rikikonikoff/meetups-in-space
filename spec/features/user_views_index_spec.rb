require 'spec_helper'

feature "User views index page" do

  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let!(:location) do
    Location.create(name: "locationplace", address: "123 poop st")
  end


  let!(:meetup_1) do
    Meetup.create(
      name: "Super Cool Meetup",
      description: "poop",
      location: location,
      creator: user
    )
  end

  let!(:meetup_2) do
    Meetup.create(
    name: "Coolest Cool Event",
    description: "akfhjkshuf",
    location: location,
    creator: user
    )
  end

  let!(:commitment_1) do
    Commitment.create(user: user, meetup: meetup_1)
  end

  let!(:commitment_2) do
    Commitment.create(user: user, meetup: meetup_2)
  end

  scenario "page displays a list of all meetups" do
    visit '/'
    sign_in_as user
    expect(page).to have_content "Super Cool Meetup"
    expect(page).to have_content "Coolest Cool Event"
  end

  scenario "meetups are listed alphabetically" do
    visit '/'
    sign_in_as user
    expect(page.find('.meetups li:nth-child(1)')).to have_content "Coolest Cool Event"
  end

  scenario "user clicks on a meeetup" do
    visit '/'
    sign_in_as user
    click_link 'Coolest Cool Event'
    expect(page).to have_content meetup_2.creator.username
    expect(page).to have_content meetup_2.location.name
    expect(page).to have_content meetup_2.location.address
    expect(page).to_not have_content meetup_1.name
  end

  scenario "user clicks on the 'add a meetup' button" do
    visit '/'
    sign_in_as user
    click_link 'Add a Meetup!'
    expect(page.find('#meetup_form')).to be_present
    expect(page).to_not have_content meetup_2.name
  end
end
