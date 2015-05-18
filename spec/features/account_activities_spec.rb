require 'spec_helper'

describe 'Account Activities' do
  before(:each) do
    FactoryGirl.create(:account_option)
  end

	describe 'Account Creation' do

		it 'should create an account with a name' do
			visit new_account_path
			fill_in 'Name', with: 'Package Deliveries Inc.'
			select 'Test', from: 'Account option'
			click_button 'Create Account'
			page.should have_content('Registration: Step 1')
		end

		it 'should create an account without a name' do
			visit new_account_path
			fill_in 'Name', with: ''
			select 'Test', from: 'Account option'
			click_button 'Create Account'
			page.should have_content("can't be blank")
		end

    it 'should not allow an email if it already exits' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:account)

      visit new_account_path
      fill_in 'Name', with: 'Package Deliveries Inc.'
      select 'Test', from: 'Account option'
      click_button 'Create Account'
      page.should have_content('Registration: Step 1')

      fill_in 'Email address', with: user.email
      click_button 'Submit'

      page.should have_content('is already registered')
    end
  end

  describe 'Account Editing' do
    before(:each) do
      @account = FactoryGirl.create(:account)
      priority = FactoryGirl.create(:priority)
      status = FactoryGirl.create(:status)
      type = FactoryGirl.create(:type)
    end

    it 'should redirect to subscriptions if the account type is changed' do
      FactoryGirl.create(:account_option, name: "Pro", cost: 40, id: 2)
      user = FactoryGirl.create(:user, master_user: true)
      group = FactoryGirl.create(:group)
      FactoryGirl.create(:membership, user: user, group: group)
      visit signin_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: "mememe"
      click_button 'Sign in'

      visit account_path(@account)

      click_link 'Edit your account'
      select 'Pro', from: 'Account option'
      click_button 'Update Account'

      page.should have_content('Account activation')
    end

  end

end