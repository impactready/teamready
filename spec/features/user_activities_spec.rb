require 'spec_helper'

describe "User Activities" do

  describe "Sign in/out" do
    describe 'show' do
      it 'should render a normal signin page if on a computer' do
        visit signin_path
        page.should have_selector('div.general-form')
      end

      it 'should render a mobile signin page if on a mobile device' do
        visit signin_path(:mobile => true)
        page.should have_selector('div.mobile-heading-block', :text => 'Sign In')
      end
    end

    describe 'failure' do
      it 'should not sign a user in' do
        visit signin_path
        fill_in 'Email', :with => ''
        fill_in 'Password', :with => ''
        click_button 'Sign in'
        page.should have_selector('div.flash_error', :text => 'Invalid username or password.')
      end

      it 'should not sign a user in using mobile views' do
        visit signin_path(:mobile => true)
        page.should have_selector('div.mobile-heading-block', :text => 'Sign In')
        fill_in 'Email', :with => ''
        fill_in 'Password', :with => ''
        click_button 'Sign in'
        page.should have_selector('div.flash_error')
        page.should have_selector('div.mobile-heading-block', :text => 'Sign In')
      end
    end

    describe "success" do
      it 'should sign a user in and out' do
        user = FactoryGirl.create(:user)
        visit signin_path
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => "mememe"
        click_button 'Sign in'
        page.should have_selector('li a', :text => 'Sign out')
        click_link 'Sign out'
        page.should have_selector('li a', :text => 'Sign in')
      end

      it 'should sign a user in and out using mobile views' do
        user = FactoryGirl.create(:user)
        visit signin_path(:mobile => true)
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => 'mememe'
        click_button 'Sign in'
        page.should have_selector('.mt-button-s', :text => 'Sign out')
        click_link 'Sign out'
        page.should have_selector('div.mobile-heading-block', :text => 'Sign in')
      end
    end
  end

  describe 'Edit details' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      visit signin_path
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => "mememe"
      click_button 'Sign in'
      visit edit_user_path(@user)
    end

    describe 'failure' do
      it "should not update a user" do
        fill_in 'First name', :with => ''
        fill_in 'Last name', :with => ''
        fill_in 'Phone', :with => ''
        within '#user_password_input' do
          fill_in 'Password', :with => ''
        end
        click_button 'Submit'
        page.should have_selector("div.flash_error")
        page.should have_content("Edit Profile")
      end
    end

    describe 'success' do
      it "should update a user" do
        fill_in 'First name', :with => 'Test'
        fill_in 'Last name', :with => 'User-Revised'
        fill_in 'Phone', :with => '27655565557'
        within '#user_password_input' do
          fill_in 'Password', :with => 'momomo'
        end
        within '#user_password_confirmation_input' do
          fill_in 'Password confirmation', :with => 'momomo'
        end
        click_button 'Submit'
        page.should have_selector("div.flash_success")
        page.should have_content("All Groups")
      end
    end

  end

end
