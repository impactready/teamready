require 'spec_helper'

describe "Group Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    @priority = FactoryGirl.create(:priority)
    @status = FactoryGirl.create(:status)
    @domain = FactoryGirl.create(:type_domain)
    @type = FactoryGirl.create(:type)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end

  describe 'Group Listing' do
    it 'should show a notice when there are no groups' do
      visit groups_path
      page.should have_content('You have not created any teams.')
    end

    it 'should show a notice when there are no items in a group' do
      group = FactoryGirl.create(:group, account: @account)
      visit groups_path
      page.should have_selector('a', text: group.name)
      page.should have_content('There are no events, tasks or stories in this team.')
    end

    it 'should show a map if an event/task/message has been created' do
      VCR.use_cassette 'requests/group_activities/group_index_with_message' do
        group = FactoryGirl.create(:group, account: @account)
        story = FactoryGirl.create(:story, user: @user, group: group, type: @domain)
        visit groups_path
        page.should have_content("Team dashboard: #{group.name}")
        page.should have_selector('td', text: '1')
      end
    end

    it 'should show updates for a group if there are any' do
      VCR.use_cassette 'requests/group_activities/group_index_with_message' do
        group = FactoryGirl.create(:group, account: @account)
        story = FactoryGirl.create(:story, user: @user, group: group, type: @domain)
        group_update = FactoryGirl.create(:update, group: group)
        visit groups_path
        page.should have_selector('div.update-item', text: group_update.detail)
      end
    end
  end

  describe 'Group Creation' do
    describe 'failure' do
      it 'should not create a new group' do
        visit new_group_path
        fill_in 'Name', with: ''
        fill_in 'Description', with: ''
        click_button 'Submit'
        page.should have_content('Create a new team')
        page.should have_selector('div.flash_error')
      end
    end

    describe 'success' do
      it 'should create a new group' do
        visit new_group_path
        fill_in 'Name', with: 'Sewer monitoring'
        fill_in 'Description', with: 'People going into sewers to check quality.'
        click_button 'Submit'
        page.should have_content('All teams')
        page.should have_selector("tr.listing-item", text: 'Sewer monitoring')
      end
    end
  end

  describe 'Group Editing' do

    before(:each) do
       @group = FactoryGirl.create(:group, account: @account)
       visit edit_group_path(@group)
    end

    describe 'failure' do
      it 'should not update the group' do
        fill_in 'Name', with: ''
        click_button 'Submit'
        page.should have_content('Edit this team')
        page.should have_selector('div.flash_error')
      end
    end

    describe 'success' do
      it 'should update the group' do
        fill_in 'Name', with: 'Sewer monitoring reviewed'
        fill_in 'Description', with: 'People going into sewers to check quality - reviewed.'
        click_button 'Submit'
        page.should have_content('All teams')
        page.should have_selector('tr.listing-item', text: 'Sewer monitoring reviewed')
      end
    end

  end

end
