require 'spec_helper'
require 'vcr'

describe "Incivent Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    @priority = FactoryGirl.create(:priority)
    @status = FactoryGirl.create(:status)
    @type = FactoryGirl.create(:type)
    @group = FactoryGirl.create(:group)
    FactoryGirl.create(:membership)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end

  describe 'Event listing' do
    it 'should render the index page' do
      VCR.use_cassette 'requests/incivent_activities/event_listing' do
        event = FactoryGirl.create(:incivent, user: @user, group: @group, priority: @priority, type: @type, status: @status)
        visit incivents_path
        page.should have_content('All events')
        page.should have_selector('tr.listing-item', text: event.name)
        page.should have_link('Priority')
      end
    end
  end

  describe 'Event new page' do
    it 'should show a new page for an event' do
      visit new_incivent_path
      page.should have_selector('.heading-block', text: 'New event')
    end

    it 'should show a mobile view for a new page for an event' do
      visit new_incivent_path(mobile: true)
      page.should have_selector('.mobile-heading-block', text: 'New event')
    end
  end

  describe 'Event creation' do
    describe 'failure' do
      it 'should not make a new event' do
        lambda do
          VCR.use_cassette 'requests/incivent_activities/event_creation_failure' do
            visit new_incivent_path
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_text('New event')
          end
        end.should_not change(Incivent, :count)
      end

      it 'should not make a new event using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/incivent_activities/event_creation_failure' do
            visit new_incivent_path(mobile: true)
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_selector('.mobile-heading-block', text: 'New event')
          end
        end.should_not change(Incivent, :count)
      end
    end


    describe 'success' do
      it 'should make a new event' do
        lambda do
          VCR.use_cassette 'requests/incivent_activities/event_creation_success' do
            visit new_incivent_path
            fill_in 'Name', with: 'Serious Oil Spill'
            fill_in 'Description', with: 'In Johannesburg'
            fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
            select @priority.description, from: 'Priority'
            select @status.description, from: 'Status'
            select @type.description, from: 'Type'
            select @group.name, from: 'Group'
            click_button 'Submit'
            page.should have_text('All events')
          end
        end.should change(Incivent, :count).by(1)
      end

      it 'should make a new event using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/incivent_activities/event_creation_success' do
            visit new_incivent_path(mobile: true)
            fill_in 'Name', with: 'Serious Oil Spill'
            fill_in 'Description', with: 'In Johannesburg'
            fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
            select @priority.description, from: 'Priority'
            select @status.description, from: 'Status'
            select @type.description, from: 'Type'
            select @group.name, from: 'Group'
            click_button 'Submit'
            page.should have_selector('.mobile-heading-block', text: 'All tasks')
          end
        end.should change(Incivent, :count).by(1)
      end
    end
  end

  describe 'Event editing' do

    describe 'failure' do
      it 'should not save an edited event' do
        VCR.use_cassette 'requests/incivent_activities/event_editing_failure' do
          event = FactoryGirl.create(:incivent, user: @user, group: @group, priority: @priority, type: @type, status: @status)
          visit edit_incivent_path(event)
          fill_in 'Name', with: ""
          fill_in 'Description', with: ""
          click_button 'Submit'
          page.should have_selector('div.flash_error')
          page.should have_content('Edit this event')
        end
      end
    end

    describe 'success' do
      it 'should save an edited event' do
        VCR.use_cassette 'requests/incivent_activities/event_editing_success' do
          event = FactoryGirl.create(:incivent, user: @user, group: @group, priority: @priority, type: @type, status: @status)
          visit edit_incivent_path(event)
          fill_in 'Name', with: 'Serious oil spill reviewed'
          fill_in 'Description', with: 'In Johannesburg.. reviewed'
          click_button 'Submit'
          page.should have_content('All events')
          page.should have_selector('tr.listing-item', text: 'Serious oil spill reviewed')
        end
      end
    end
  end

  describe 'Event showing' do
    it 'should show an event' do
      VCR.use_cassette 'requests/incivent_activities/event_show' do
        event = FactoryGirl.create(:incivent, user: @user, group: @group, priority: @priority, type: @type, status: @status)
        visit incivent_path(event)
        page.should have_content('Event')
        page.should have_selector('tr.listing-item', text: event.name)
      end
    end
  end

  describe 'Event deleting' do
    it "should delete an incivent on the show page" do
      VCR.use_cassette 'requests/incivent_activities/event_delete' do
        event = FactoryGirl.create(:incivent, user: @user, group: @group, priority: @priority, type: @type, status: @status)
        visit incivent_path(event)
        click_link 'Delete this event'
        page.should have_selector('div.flash_success', text: 'Event removed.')
      end
    end
  end

end
