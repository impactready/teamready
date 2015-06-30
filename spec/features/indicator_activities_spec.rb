require 'spec_helper'

describe "Indicator Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end


  describe 'Indicator listing' do
    it "should direct from account view to indicators" do
      visit account_path(@account)
      click_link 'Manage indicators'
      page.should have_content('Indicator options')
    end

    it "should not create a new indicator option" do
      indicator = FactoryGirl.create(:indicator, account: @account)
      visit indicators_path
      page.should have_selector('tr.listing-item', text: indicator.description)
    end
  end


  describe 'Indicator creation' do
    before(:each) do
      visit indicators_path
      click_link 'New indicator'
    end

    describe 'failure' do
      it "should not create a indicator" do
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('New indicator')
      end
    end

    describe 'success' do
      it "should create a indicator" do
        fill_in 'Description', with: "Housing type"
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Indicator options')
      end
    end
  end

  describe 'Indicator editing' do

    before(:each) do
      @indicator = FactoryGirl.create(:indicator, account: @account)
      visit indicators_path
      click_link 'Edit'
    end

    describe 'failure' do
      it "should not update a indicator" do
        fill_in 'Description', with: ''
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('Edit indicator')
      end
    end

    describe 'success' do
      it "should update a indicator" do
        fill_in 'Description', with: 'Open Reviewed'
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Indicator options')
      end
    end

  end

end