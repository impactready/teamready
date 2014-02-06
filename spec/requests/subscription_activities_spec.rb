require 'spec_helper'

describe 'Subscription Activities' do

  before(:each) do
    account_option = FactoryGirl.create(:account_option, cost: 40)
    account = FactoryGirl.create(:account, account_option: account_option)
    @user = FactoryGirl.create(:user, master_user: true, account: account)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'mememe'
    click_button 'Sign in'
  end

  describe 'Redirects' do
    it 'should redirect as payment is not active' do
      visit groups_path
      page.should have_content('Please enter the activation code')
    end
  end

  describe 'Activation codes' do
    it 'should now allow signup with the wrong activation code' do
      visit new_subscription_path
      fill_in 'Code', with: 'aEEREerd2234432z'
      click_button 'Submit'
      page.should have_content('The activation code is not valid')
    end

    it 'should allow signup with the correct activation code' do
      visit new_subscription_path
      fill_in 'Code', with: 'a3EEREerd2234432z'
      click_button 'Submit'
      page.should have_content('Your account is now active')
    end
  end
end