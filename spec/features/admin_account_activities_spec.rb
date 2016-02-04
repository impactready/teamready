require 'spec_helper'

describe 'Account Activities', type: :feature do
  before(:each) do
    FactoryGirl.create(:account_option)
  end

  describe 'Account Creation' do

    before(:each) do
      @user = FactoryGirl.create(:user, master_user: true, admin_user: true)
      FactoryGirl.create(:account)

      visit signin_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Sign in'
    end

    it 'should create an account with a name' do
      visit new_admin_account_path
      fill_in 'Name', with: 'Package Deliveries Inc.'
      select 'Test', from: 'Account option'
      click_button 'Create Account'
      page.should have_content('Invite a user to your account')
    end

    it 'should create an account without a name' do
      visit new_admin_account_path
      fill_in 'Name', with: ''
      select 'Test', from: 'Account option'
      click_button 'Create Account'
      page.should have_content("can't be blank")
    end

    it 'should create and account and send details to an email address' do
      visit new_admin_account_path
      fill_in 'Name', with: 'Package Deliveries Inc.'
      select 'Test', from: 'Account option'
      select 'Yes', from: 'Active'
      click_button 'Create Account'

      page.should have_content('Invite a user to your account')

      fill_in 'Email address', with: 'person999@example.com'
      click_button 'Submit'

      page.should have_content('Account Administration')
    end

    it 'should not allow an email if it already exits' do
      visit new_admin_account_path
      fill_in 'Name', with: 'Package Deliveries Inc.'
      select 'Test', from: 'Account option'
      click_button 'Create Account'
      page.should have_content('Invite a user to your account')

      fill_in 'Email address', with: @user.email
      click_button 'Submit'

      page.should have_content('is already registered')
    end
  end

  describe 'Account Listing' do
    before(:each) do
      @account = FactoryGirl.create(:account)
      user = FactoryGirl.create(:user, master_user: true, admin_user: true)
      priority = FactoryGirl.create(:priority)
      status = FactoryGirl.create(:status)
      type = FactoryGirl.create(:type)
      group = FactoryGirl.create(:group)
      FactoryGirl.create(:membership)
      visit signin_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: "mememe"
      click_button 'Sign in'
    end

    it 'should list all accounts' do
      visit admin_accounts_path

      page.should have_content(@account.name)
    end

    it 'should redirect to the new acccounts path for creating a new account' do
      visit admin_accounts_path

      click_link 'New account'

      page.should have_content('Create a new account')
    end
  end

  describe 'Account Editing' do
    before(:each) do
      @account = FactoryGirl.create(:account)
      priority = FactoryGirl.create(:priority)
      status = FactoryGirl.create(:status)
      type = FactoryGirl.create(:type)
    end

    it 'should allow editing for god users' do
      user = FactoryGirl.create(:user, master_user: true, admin_user: true)
      visit signin_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: "mememe"
      click_button 'Sign in'

      visit admin_accounts_path
      click_link 'Edit'
      fill_in 'Name', with: 'Environmental Militants!'
      click_button 'Update Account'

      page.should have_content('Environmental Militants!')
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