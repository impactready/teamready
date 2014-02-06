require 'spec_helper'
require 'vcr'

describe "Task Activities" do

  before(:each) do
    @user = FactoryGirl.create(:user, :master_user => true)
    @account = @user.account
    @priority = FactoryGirl.create(:priority, :account => @account)
    @status = FactoryGirl.create(:status, :account => @account)
    @group = FactoryGirl.create(:group, :account => @account)
    FactoryGirl.create(:membership, :user => @user, :group => @group)
    visit signin_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => "mememe"
    click_button 'Sign in'
  end

  describe 'Task listing' do

    it 'should show a notice when there are no tasks on a mobile view' do
      visit tasks_path(:mobile => true)
      page.should have_content('You do not have any tasks assigned to you.')
      page.should have_selector('div.mobile-heading-block', :content => 'All Tasks')
    end

    it 'should render the index page' do
      VCR.use_cassette 'requests/task_activities/task_index' do
        task = FactoryGirl.create(:task, :user => @user, :group => @group, :priority => @priority, :raised_user_id => @user.id, :status => @status)
        visit "/tasks/"
        page.should have_content('All Tasks')
        page.should have_selector("tr.listing-item", :text => task.description)
        page.should have_link("Priority")
      end
    end

    it 'should show a list on a mobile view if an event/task/message has been created' do
      VCR.use_cassette 'requests/task_activities/task_index' do
        task = FactoryGirl.create(:task, :user => @user, :group => @group, :priority => @priority, :raised_user_id => @user.id, :status => @status)
        visit tasks_path(:mobile => true)
        page.should have_content(task.description)
      end
    end
  end

  describe 'Task new page' do
    it 'should show a new page for an task' do
      visit new_incivent_path
      page.should have_selector('.heading-block', :content => 'New Task')
    end

    it 'should show a mobile view for a new page for an task' do
      visit new_incivent_path(:mobile => true)
      page.should have_selector('.mobile-heading-block', :content => 'New Task')
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
            page.should have_content('Add a Task')
          end
        end.should_not change(Task, :count)
      end

      it 'should not make a new task using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_failure' do
            visit new_task_path(:mobile => true)
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_selector('.mobile-heading-block', :content => 'New Task')
          end
        end.should_not change(Task, :count)
      end
    end

    describe 'success' do
      it 'should make a new task' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_success' do
            visit new_task_path
            fill_in 'Description', :with => 'Do something now.'
            fill_in 'Location', :with => '20 Corlett Drive, Johannesburg'
            select @priority.description, :from => 'Priority'
            select @status.description, :from => 'Status'
            select @group.name, :from => 'Group'
            select @user.full_name, :from => 'User'
            fill_in 'Due date', :with => '2014-06-24'
            click_button 'Submit'
            page.should have_content('All Tasks')
            page.should have_selector('tr.listing-item', :text => "Do something now.")
          end
        end.should change(Task, :count).by(1)
      end

      it 'should make a new task using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_success' do
            visit new_task_path(:mobile => true)
            fill_in 'Description', :with => 'Do something now.'
            fill_in 'Location', :with => '20 Corlett Drive, Johannesburg'
            select @priority.description, :from => 'Priority'
            select @status.description, :from => 'Status'
            select @group.name, :from => 'Group'
            select @user.full_name, :from => 'User'
            fill_in 'Due date', :with => '2014-06-24'
            click_button 'Submit'
            page.should have_selector('.mobile-heading-block', :content => 'All Tasks')
          end
        end.should change(Task, :count).by(1)
      end
    end
  end

  describe 'Task bulk creation' do
    describe 'failure' do
      it 'should not create tasks through the bulk interface' do
        VCR.use_cassette 'requests/task_activities/task_creation_bulk' do
          visit bulk_new_tasks_path(:group_id => @group.id)
          click_button 'Submit'
          page.should have_content('All Groups')
        end
      end
    end

    describe 'success' do
      it 'successfully creates tasks through the bulk interface' do
        lambda do
          VCR.use_cassette 'requests/task_activities/task_creation_bulk' do
            visit bulk_new_tasks_path(:group_id => @group.id)
            find(:css, "input[id*='description']").set('Do something now')
            find(:css, "input[id*='location']").set('20 Corlett Drive, Johannesburg')
            find(:css, "select[id*='priority']").set(@priority.description)
            find(:css, "select[id*='status']").set(@status.description)
            find(:css, "select[id*='user']").set(@user.full_name)
            find(:css, "input[id*='due_date']").set('2014-10-24')
            click_button 'Submit'
            page.should have_content('All Groups')
          end
        end.should change(@group.tasks, :count).by(1)
      end
    end
  end


  describe 'Task editing' do
    before(:each) do
      VCR.use_cassette 'requests/task_activities/task_editing_creation' do
        @task = FactoryGirl.create(:task, :user => @user, :group => @group, :priority => @priority, :raised_user_id => @user.id, :status => @status)
      end
    end

    describe 'failure' do
      it 'should not save an edited task' do
        VCR.use_cassette 'requests/task_activities/task_editing_success' do
          visit edit_task_path(@task)
          fill_in 'Description', :with => ""
          click_button 'Submit'
          page.should have_selector('div.flash_error')
          page.should have_content('Edit this Task')
        end
      end
    end

    describe 'success' do
      it 'should save an edited task' do
        VCR.use_cassette 'requests/task_activities/task_editing_failure' do
          visit edit_task_path(@task)
          fill_in 'Description', :with => 'Do something now.. reviewed'
          fill_in 'Location', :with => '19 Corlett Drive, Johannesburg'
          click_button 'Submit'
          page.should have_content('All Tasks')
          page.should have_selector('tr.listing-item', :text => 'Do something now.. reviewed')
        end
      end
    end
  end

  describe 'Task showing' do
    it 'should show a task' do
      VCR.use_cassette 'requests/task_activities/task_show' do
        task = FactoryGirl.create(:task, :user => @user, :group => @group, :priority => @priority, :raised_user_id => @user.id, :status => @status)
        visit task_path(task)
        page.should have_content('Task')
        page.should have_selector('tr.listing-item', :text => task.description)
      end
    end
  end

  describe 'Task deleting' do
    it 'should show delete task' do
      VCR.use_cassette 'requests/task_activities/task_delete' do
        task = FactoryGirl.create(:task, :user => @user, :group => @group, :priority => @priority, :raised_user_id => @user.id, :status => @status)
        visit task_path(task)
        click_link('Delete this Task')
        page.should have_selector('div.flash_success', :text => 'Task removed.')
      end
    end
  end
end
