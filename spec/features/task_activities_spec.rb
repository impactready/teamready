require 'spec_helper'
require 'vcr'

describe "Task Activities", type: :feature do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    @priority = FactoryGirl.create(:priority)
    @status = FactoryGirl.create(:status)
    @group = FactoryGirl.create(:group)
    FactoryGirl.create(:membership)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end

  describe 'Task listing' do

    it 'should show a notice when there are no tasks on a mobile view' do
      visit tasks_path(mobile: true)
      page.should have_content('You do not have any tasks assigned to you.')
      page.should have_selector('div.mobile-heading-block', text: 'All tasks')
    end

    it 'should render the index page' do
      VCR.use_cassette 'requests/task_activities/task_index' do
        task = FactoryGirl.create(:task, user: @user, group: @group, priority: @priority, raised_user_id: @user.id, status: @status)
        visit "/tasks/"
        page.should have_content('All tasks')
        page.should have_selector("tr.listing-item", text: task.description)
        page.should have_link("Priority")
      end
    end

    it 'should show a list on a mobile view if an event/task/message has been created' do
      VCR.use_cassette 'requests/task_activities/task_index' do
        task = FactoryGirl.create(:task, user: @user, group: @group, priority: @priority, raised_user_id: @user.id, status: @status)
        visit tasks_path(mobile: true)
        page.should have_content(task.description)
      end
    end
  end

  describe 'Task new page' do
    it 'should show a new page for an task' do
      visit new_task_path
      page.should have_selector('.heading-block', text: 'New task')
    end

    it 'should show a mobile view for a new page for an task' do
      visit new_task_path(mobile: true)
      page.should have_selector('.mobile-heading-block', text: 'New task')
    end
  end

  describe 'Task creation' do
    describe 'failure' do
      it "should not make a new task" do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_failure' do
            visit new_task_path
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_content('New task')
          end
        end.should_not change(Task, :count)
      end

      it 'should not make a new task using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_failure' do
            visit new_task_path(mobile: true)
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_selector('.mobile-heading-block', text: 'New task')
          end
        end.should_not change(Task, :count)
      end
    end

    describe 'success' do
      it 'should make a new task' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_success' do
            visit new_task_path
            fill_in 'Description', with: 'Do something now.'
            fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
            select @priority.description, from: 'Priority'
            select @status.description, from: 'Status'
            select @group.name, from: 'Team'
            select @user.full_name, from: 'User'
            fill_in 'Due date', with: '2014-06-24'
            click_button 'Submit'
            page.should have_content('All tasks')
            page.should have_selector('tr.listing-item', text: "Do something now.")
          end
        end.should change(Task, :count).by(1)
      end

      it 'should make a new task using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_success' do
            visit new_task_path(mobile: true)
            fill_in 'Description', with: 'Do something now.'
            fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
            select @priority.description, from: 'Priority'
            select @status.description, from: 'Status'
            select @group.name, from: 'Team'
            select @user.full_name, from: 'User'
            fill_in 'Due date', with: '2014-06-24'
            click_button 'Submit'
            page.should have_selector('.mobile-heading-block', text: 'All tasks')
          end
        end.should change(Task, :count).by(1)
      end
    end
  end


  describe 'Task editing' do
    before(:each) do
      VCR.use_cassette 'requests/task_activities/task_editing_creation' do
        @task = FactoryGirl.create(:task, user: @user, group: @group, priority: @priority, raised_user_id: @user.id, status: @status)
      end
    end

    describe 'failure' do
      it 'should not save an edited task' do
        VCR.use_cassette 'requests/task_activities/task_editing_success' do
          visit edit_task_path(@task)
          fill_in 'Description', with: ""
          click_button 'Submit'
          page.should have_selector('div.flash_error')
          page.should have_content('Edit this task')
        end
      end
    end

    describe 'success' do
      it 'should save an edited task' do
        VCR.use_cassette 'requests/task_activities/task_editing_failure' do
          visit edit_task_path(@task)
          fill_in 'Description', with: 'Do something now.. reviewed'
          fill_in 'Location', with: '19 Corlett Drive, Johannesburg'
          click_button 'Submit'
          page.should have_content('All tasks')
          page.should have_selector('tr.listing-item', text: 'Do something now.. reviewed')
        end
      end
    end
  end

  describe 'Task showing' do
    it 'should show a task' do
      VCR.use_cassette 'requests/task_activities/task_show' do
        task = FactoryGirl.create(:task, user: @user, group: @group, priority: @priority, raised_user_id: @user.id, status: @status)
        visit task_path(task)
        page.should have_content('Task')
        page.should have_selector('tr.listing-item', text: task.description)
      end
    end
  end

  describe 'Task deleting' do
    it 'should show delete task' do
      VCR.use_cassette 'requests/task_activities/task_delete' do
        task = FactoryGirl.create(:task, user: @user, group: @group, priority: @priority, raised_user_id: @user.id, status: @status)
        visit task_path(task)
        click_link('Delete this task')
        page.should have_selector('div.flash_success', text: 'Task removed.')
      end
    end
  end
end
