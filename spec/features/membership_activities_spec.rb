require 'spec_helper'

describe "Membership Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    @priority = FactoryGirl.create(:priority)
    @status = FactoryGirl.create(:status)
    @type = FactoryGirl.create(:type)
    @group = FactoryGirl.create(:group)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end

  describe 'joining' do
    it "should not create a membership" do
        visit user_admin_groups_path(@user)
        click_button 'Assign'
        page.should have_selector("tr.listing-item", text: 'Assigned')
    end
  end

  describe 'leaving' do
    it "should delete a membership " do
        FactoryGirl.create(:membership, user: @user, group: @group)
        visit user_admin_groups_path(@user)
        click_button 'Unassign'
        page.should have_selector("tr.listing-item", text: 'Not Assigned')
    end
  end


end