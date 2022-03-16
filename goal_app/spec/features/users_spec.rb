require 'rails_helper'
require 'spec_helper'

feature 'the signup process', type: :feature do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "New User"
  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in('Username:', with: 'Kelly')
      fill_in('Password:', with: 'password')    
      click_on "create user"  
    end

    scenario "redirects to users show page" do
      expect(page).to have_content "Welcome"
    end
  end

  feature "with invalid user" do
    before(:each) do
      visit new_user_url
      fill_in('Username:', with: "Kelly")
      fill_in('Password:', with: '')    
      click_on "create user"  
    end

    scenario "renders the new form and shows errors" do
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
    end
  end
end