require 'spec_helper'

describe "Type Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end


  describe 'Type listing' do
    it "should direct from account view to statuses" do
      visit account_path(@account)
      click_link 'Manage types / domains / indicators'
      page.should have_content('Type options')
    end

    it "should not create a new type option" do
      type = FactoryGirl.create(:type, account: @account)
      visit types_path
      page.should have_selector('tr.listing-item', text: type.description)
    end
  end


  describe 'Type creation' do

    describe 'failure' do
      it "should not create a type option" do
        visit types_path
        click_link 'New event type'
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('New type')
      end
    end

    describe 'success' do
      it "should not create a type option" do
        visit new_type_path
        fill_in 'Description', with: "Environmental"
        select 'Event category', from: 'Usage'
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Type options')
      end
    end
  end

  describe 'Type editing' do

    before(:each) do
      @type = FactoryGirl.create(:type, account: @account)
      visit types_path
      click_link 'Edit'
    end

    describe 'failure' do
      it "should not update a type option" do
        fill_in 'Description', with: ''
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('Edit type')
      end
    end

    describe 'success' do
      it "should update a type option" do
        fill_in 'Description', with: 'Environmental Reviewd'
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Type options')
      end
    end

  end

end