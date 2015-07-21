require 'spec_helper'
require 'vcr'

describe 'Story Activities' do
	before(:each) do
		FactoryGirl.create(:account_option)
		@domain = FactoryGirl.create(:type_domain)
		@user = FactoryGirl.create(:user, master_user: true)
    @account = FactoryGirl.create(:account)
		@group = FactoryGirl.create(:group)
		FactoryGirl.create(:membership)
		visit signin_path
		fill_in 'Email', with: @user.email
		fill_in 'Password', with: "mememe"
		click_button 'Sign in'
	end

	describe 'Story Listing' do

		it 'should render the index page' do
			VCR.use_cassette 'requests/story_activities/story_index' do
			  story = FactoryGirl.create(:story, user: @user, group: @group, type: @domain)
			  visit stories_path
		  	page.should have_content('All stories')
		    page.should have_selector('tr.listing-item', text: story.description)
		    page.should have_link('Posted by')
	    end
	  end
	end

	describe 'Story new page' do
	  it 'should show a new page for a story' do
	    visit new_story_path
	    page.should have_selector('.heading-block', text: 'New story')
	  end

	  it 'should show a mobile view for a new page for a story' do
	    visit new_story_path(mobile: true)
	    page.should have_selector('.mobile-heading-block', text: 'New story')
	  end
	end

	describe 'Story creation' do
		describe 'failure' do
			it "should not create a new story" do
				lambda do
					VCR.use_cassette 'requests/story_activities/story_creation_failure' do
					  visit new_story_path
					  click_button 'Submit'
					  page.should have_selector('div.flash_error')
					  page.should have_content('New story')
					end
				end.should_not change(Story, :count)
			end

			it 'should not make a new story using mobile views on a mobile device' do
			  lambda do
			    VCR.use_cassette 'requests/story_activities/story_creation_failure' do
			      visit new_story_path(mobile: true)
			      click_button 'Submit'
			      page.should have_selector('div.flash_error')
			      page.should have_selector('.mobile-heading-block', text: 'New story')
			    end
			  end.should_not change(Story, :count)
			end
		end

		describe "success" do
		  it "should create a new story" do
		  	lambda do
		  		VCR.use_cassette 'requests/story_activities/story_creation_success' do
				    visit new_story_path
				    fill_in 'Description', with: 'Our customers were very happy!'
				    fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
				    select @domain.description, from: 'Domain of change'
				    select @group.name, from: 'Team'
				    click_button 'Submit'
				    page.should have_content('All stories')
				  end
			  end.should change(Story, :count).by(1)
		  end

		  it 'should make a new story using mobile views on a mobile device' do
		    lambda do
		      VCR.use_cassette 'requests/story_activities/story_creation_success' do
		        visit new_story_path(mobile: true)
		        fill_in 'Description', with: 'Our customers were very happy!'
		        fill_in 'Location', with: '20 Corlett Drive, Johannesburg'
		        select @domain.description, from: 'Domain of change'
		        select @group.name, from: 'Team'
		        click_button 'Submit'
		        page.should have_selector('.mobile-heading-block', text: 'All tasks')
		      end
		    end.should change(Story, :count).by(1)
		  end
		end
	end

	describe 'Story editing' do
		before(:each) do
			VCR.use_cassette 'requests/story_activities/story_editing_creation' do
			  @story = FactoryGirl.create(:story, user: @user, group: @group)
			  visit edit_story_path(@story)
			end
		end

		describe 'failure' do
		  it 'should not update a edited story' do
		  	VCR.use_cassette 'requests/story_activities/story_editing_failure' do
			    fill_in 'Description', with: ""
			    click_button 'Submit'
			    page.should have_selector('div.flash_error')
			    page.should have_content('Edit this story')
			  end
		  end
		end

		describe 'success' do
		  it 'should update a edited story' do
		  	VCR.use_cassette 'requests/story_activities/story_editing_success' do
			    fill_in 'Description', with: 'Our customers were not happy..'
			    fill_in 'Location', with: '19 Corlett Drive, Johannesburg'
			    click_button 'Submit'
			    page.should have_content('All stories')
			    page.should have_selector('tr.listing-item', text: 'Our customers were not happy..')
			  end
		  end
		end
	end

	describe 'Story showing' do
	  it 'should show an story' do
	  	VCR.use_cassette 'requests/story_activities/story_show' do
		  	story = FactoryGirl.create(:story, user: @user, group: @group)
		    visit story_path(story)
		    page.should have_content('Story')
		    page.should have_selector('tr.listing-item', text: story.description)
		  end
	  end
	end

	describe 'Story deleting' do
	  it 'should delete a story' do
	  	VCR.use_cassette 'requests/story_activities/story_delete' do
		  	story = FactoryGirl.create(:story, user: @user, group: @group)
		    visit story_path(story)
		    click_link 'Delete this story'
		    page.should have_selector('div.flash_success', text: 'Story removed.')
		  end
	  end
	end
end
