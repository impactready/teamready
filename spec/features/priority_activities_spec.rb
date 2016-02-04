require 'spec_helper'

describe "Priority Activities", type: :feature do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end


  describe 'Priority listing' do
    it "should direct from account view to priorities" do
      visit account_path(@account)
      click_link 'Manage priority options'
      page.should have_content('Priority options')
    end

    it "should not create a new priority option" do
      priority = FactoryGirl.create(:priority, account: @account)
      visit priorities_path
      page.should have_selector('tr.listing-item', text: priority.description)
    end
  end


  describe 'Priority creation' do
    before(:each) do
      visit priorities_path
      click_link 'New priority option'
    end

    describe 'failure' do
      it "should not create a priority option" do
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('New priority')
      end
    end

    describe 'success' do
      it 'should create a priority option' do
        fill_in 'Description', with: "Not so High"
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Priority options')
      end
    end
  end

  describe 'Priority editing' do

    before(:each) do
      @priority = FactoryGirl.create(:priority, account: @account)
      visit priorities_path
      click_link 'Edit'
    end

    describe 'failure' do
      it "should not update a priority option" do
        fill_in 'Description', with: ''
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('Edit priority')
      end
    end

    describe 'success' do
      it "should update a priority option" do
        fill_in 'Description', with: 'High'
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Priority options')
      end
    end

  end

end