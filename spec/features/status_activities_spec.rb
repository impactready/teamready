require 'spec_helper'

describe "Status Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end


  describe 'Status listing' do
    it "should not create a new status option" do
      status = FactoryGirl.create(:status, account: @account)
      visit statuses_path
      page.should have_selector('tr.listing-item', text: status.description)
    end
  end


  describe 'Status creation' do

    describe 'failure' do
      it "should not create a status option" do
        visit new_status_path
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('New status')
      end
    end

    describe 'success' do
      it "should not create a status option" do
        visit new_status_path
        fill_in 'Description', with: "Closed"
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Status options')
      end
    end
  end

  describe 'Status editing' do

    before(:each) do
      @status = FactoryGirl.create(:status, account: @account)
      visit edit_status_path(@status)
    end

    describe 'failure' do
      it "should not update a status option" do
        fill_in 'Description', with: ''
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('Edit status')
      end
    end

    describe 'success' do
      it "should update a status option" do
        fill_in 'Description', with: 'Open Reviewed'
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Status options')
      end
    end

  end

end