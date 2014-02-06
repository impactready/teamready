require 'spec_helper'

describe "Type Activities" do

  before(:each) do
    @user = FactoryGirl.create(:user, :master_user => true)
    @account = @user.account
    visit signin_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => "mememe"
    click_button 'Sign in'
  end


  describe 'Type listing' do
    it "should not create a new type option" do
      type = FactoryGirl.create(:type, :account => @account)
      visit types_path
      page.should have_selector('tr.listing-item', :text => type.description)
    end
  end


  describe 'Type creation' do

    describe 'failure' do
      it "should not create a type option" do
        visit new_type_path
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('New Type')
      end
    end

    describe 'success' do
      it "should not create a type option" do
        visit new_type_path
        fill_in 'Description', :with => "Environmental"
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Type Options')
      end
    end
  end

  describe 'Type editing' do

    before(:each) do
      @type = FactoryGirl.create(:type, :account => @account)
      visit edit_type_path(@type)
    end

    describe 'failure' do
      it "should not update a type option" do
        fill_in 'Description', :with => ''
        click_button 'Submit'
        page.should have_selector('div.flash_error')
        page.should have_content('Edit Type')
      end
    end

    describe 'success' do
      it "should update a type option" do
        fill_in 'Description', :with => 'Environmental Reviewd'
        click_button 'Submit'
        page.should have_selector('div.flash_success')
        page.should have_content('Type Options')
      end
    end

  end

end