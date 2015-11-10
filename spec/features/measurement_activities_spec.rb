require 'spec_helper'
require 'vcr'

describe "Measurement Activities" do

  before(:each) do
    FactoryGirl.create(:account_option)
    @user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
    @type = FactoryGirl.create(:type_indicator)
    @group = FactoryGirl.create(:group)
    FactoryGirl.create(:membership)
    visit signin_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "mememe"
    click_button 'Sign in'
  end

  describe 'Measurement listing' do
    it 'should render the index page' do
      VCR.use_cassette 'requests/measurement_activities/measurement_listing' do
        measurement = FactoryGirl.create(:measurement, user: @user, group: @group, type: @type)
        visit measurements_path
        page.should have_content('All indicator measurements')
        page.should have_selector('tr.listing-item', text: measurement.description)
        page.should have_link('Indicator')
      end
    end
  end

  describe 'Measurement new page' do
    it 'should show a new page for an measurement' do
      visit new_measurement_path
      page.should have_selector('.heading-block', text: 'New indicator measurement')
    end

    it 'should show a mobile view for a new page for an measurement' do
      visit new_measurement_path(mobile: true)
      page.should have_selector('.mobile-heading-block', text: 'New indicator measurement')
    end
  end

  describe 'Measurement creation' do
    describe 'failure' do
      it 'should not make a new measurement' do
        lambda do
          VCR.use_cassette 'requests/measurement_activities/measurement_creation_failure' do
            visit new_measurement_path
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_text('New indicator measurement')
          end
        end.should_not change(Measurement, :count)
      end

      it 'should not make a new measurement using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/measurement_activities/measurement_creation_failure' do
            visit new_measurement_path(mobile: true)
            click_button 'Submit'
            page.should have_selector('div.flash_error')
            page.should have_selector('.mobile-heading-block', text: 'New indicator measurement')
          end
        end.should_not change(Measurement, :count)
      end
    end


    describe 'success' do
      it 'should make a new measurement' do
        lambda do
          VCR.use_cassette 'requests/measurement_activities/measurement_creation_success' do
            visit new_measurement_path
            fill_in 'Description', with: 'In Johannesburg'
            fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
            select @type.description, from: 'Indicator'
            select @group.name, from: 'Team'
            click_button 'Submit'
            page.should have_text('All indicator measurements')
          end
        end.should change(Measurement, :count).by(1)
      end

      it 'should make a new measurement using mobile views on a mobile device' do
        lambda do
          VCR.use_cassette 'requests/measurement_activities/measurement_creation_success' do
            visit new_measurement_path(mobile: true)
            fill_in 'Description', with: 'In Johannesburg'
            fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
            select @type.description, from: 'Indicator'
            select @group.name, from: 'Team'
            click_button 'Submit'
            page.should have_selector('.mobile-heading-block', text: 'All tasks')
          end
        end.should change(Measurement, :count).by(1)
      end
    end
  end

  describe 'Measurement editing' do

    describe 'failure' do
      it 'should not save an edited measurement' do
        VCR.use_cassette 'requests/measurement_activities/measurement_editing_failure' do
          measurement = FactoryGirl.create(:measurement, user: @user, group: @group, type: @type)
          visit edit_measurement_path(measurement)
          fill_in 'Description', with: ""
          click_button 'Submit'
          page.should have_selector('div.flash_error')
          page.should have_content('Edit this indicator measurement')
        end
      end
    end

    describe 'success' do
      it 'should save an edited measurement' do
        VCR.use_cassette 'requests/measurement_activities/measurement_editing_success' do
          measurement = FactoryGirl.create(:measurement, user: @user, group: @group, type: @type)
          visit edit_measurement_path(measurement)
          fill_in 'Description', with: 'In Johannesburg.. reviewed'
          click_button 'Submit'
          page.should have_content('All indicator measurements')
          page.should have_selector('tr.listing-item', text: 'In Johannesburg.. reviewed')
        end
      end
    end
  end

  describe 'Measurement showing' do
    it 'should show an measurement' do
      VCR.use_cassette 'requests/measurement_activities/measurement_show' do
        measurement = FactoryGirl.create(:measurement, user: @user, group: @group, type: @type)
        visit measurement_path(measurement)
        page.should have_content('Indicator measurement')
        page.should have_selector('tr.listing-item', text: measurement.description)
      end
    end
  end

  describe 'Measurement deleting' do
    it "should delete an measurement on the show page" do
      VCR.use_cassette 'requests/measurement_activities/measurement_delete' do
        measurement = FactoryGirl.create(:measurement, user: @user, group: @group, type: @type)
        visit measurement_path(measurement)
        click_link 'Delete this measurement'
        page.should have_selector('div.flash_success', text: 'Indicator measurement removed.')
      end
    end
  end

end
