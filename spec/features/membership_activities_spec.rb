require 'spec_helper'

describe "Membership Activities" do

  before(:each) do
    @user = FactoryGirl.create(:user, :master_user => true)
    @account = @user.account
    @priority = FactoryGirl.create(:priority, :account => @account)
    @status = FactoryGirl.create(:status, :account => @account)
    @type = FactoryGirl.create(:type, :account => @account)
    @group = FactoryGirl.create(:group, :account => @account)
    visit signin_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => "mememe"
    click_button 'Sign in'
  end

  describe 'joining' do
    it "should not create a membership" do
        visit user_admin_groups_path(@user)
        click_button 'Assign'
        page.should have_selector("tr.listing-item", :text => 'Assigned')
    end
  end

  describe 'leaving' do
    it "should delete a membership " do
        FactoryGirl.create(:membership, :user => @user, :group => @group)
        visit user_admin_groups_path(@user)
        click_button 'Unassign'
        page.should have_selector("tr.listing-item", :text => 'Not Assigned')
    end
  end


end