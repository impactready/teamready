require 'spec_helper'

describe 'SignUp Activities' do

  before(:each) do
    @account = FactoryGirl.create(:account)
    @invitation = FactoryGirl.create(:invitation, :account_id => @account.id)
    @url = signup_url + '/' + @invitation.token
  end

  describe 'loading' do
    it 'should have an email address' do
        visit @url
        page.should have_content('Registration: Step 2')
        page.has_field?('Email', :with => @invitation.recipient_email)
    end
  end

  describe 'registration' do

    describe 'failure 1' do
      it 'should not allow signup' do
          visit @url
          fill_in 'First name', :with => ''
          fill_in 'Last name', :with => ''
          fill_in 'Phone', :with => ''
          fill_in 'Password', :with => 'mememe'
          fill_in 'Password confirmation', :with => 'mememe'

          click_button 'Submit'
          page.should have_selector("li.error")
      end
    end

    describe 'failure 2' do
      it 'should not allow signup' do
          visit @url
          fill_in 'First name', :with => 'Test'
          fill_in 'Last name', :with => 'User'
          fill_in 'Phone', :with => ''
          fill_in 'Password', :with => ''
          fill_in 'Password confirmation', :with => ''

          click_button 'Submit'
          page.should have_selector("li.error")
      end
    end

    describe 'success' do
      it 'should allow signup ' do
          visit @url
          fill_in 'First name', :with => 'Test'
          fill_in 'Last name', :with => 'User'
          fill_in 'Phone', :with => ''
          fill_in 'Password', :with => 'mememe'
          fill_in 'Password confirmation', :with => 'mememe'
          click_button 'Submit'
          page.should have_content('All Groups')
      end
    end
  end

end