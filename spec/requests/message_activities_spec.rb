require 'spec_helper'
require 'vcr'

describe 'Message Activities' do
	before(:each) do
		@user = FactoryGirl.create(:user, :master_user => true)
		@account = @user.account
		@group = FactoryGirl.create(:group, :account => @account)
		FactoryGirl.create(:membership, :user => @user, :group => @group)
		visit signin_path
		fill_in 'Email', :with => @user.email
		fill_in 'Password', :with => "mememe"
		click_button 'Sign in'
	end

	describe 'Message Listing' do

		it 'should render the index page' do
			VCR.use_cassette 'requests/message_activities/message_index' do
			  message = FactoryGirl.create(:message, :user => @user, :group => @group)
			  visit messages_path
		  	page.should have_content('All Messages')
		    page.should have_selector('tr.listing-item', :text => message.description)
		    page.should have_link('Posted by')
	    end
	  end
	end

	describe 'Message new page' do
	  it 'should show a new page for a message' do
	    visit new_incivent_path
	    page.should have_selector('.heading-block', :content => 'New Message')
	  end

	  it 'should show a mobile view for a new page for a message' do
	    visit new_incivent_path(:mobile => true)
	    page.should have_selector('.mobile-heading-block', :content => 'New Message')
	  end
	end

	describe 'Message creation' do
		describe 'failure' do
			it "should not create a new message" do
				lambda do
					VCR.use_cassette 'requests/message_activities/message_creation_failure' do
					  visit new_message_path
					  click_button 'Submit'
					  page.should have_selector('div.flash_error')
					  page.should have_content('Add a Message')
					end
				end.should_not change(Message, :count)
			end

			it 'should not make a new message using mobile views on a mobile device' do
			  lambda do
			    VCR.use_cassette 'requests/message_activities/message_creation_failure' do
			      visit new_message_path(:mobile => true)
			      click_button 'Submit'
			      page.should have_selector('div.flash_error')
			      page.should have_selector('.mobile-heading-block', :content => 'New Message')
			    end
			  end.should_not change(Incivent, :count)
			end
		end

		describe "success" do
		  it "should create a new message" do
		  	lambda do
		  		VCR.use_cassette 'requests/message_activities/message_creation_success' do
				    visit new_message_path
				    fill_in 'Description', :with => 'Our customers were very happy!'
				    fill_in 'Location', :with => '20 Corlett Drive, Johannesburg'
				    select @group.name, :from => 'Group'
				    click_button 'Submit'
				    page.should have_content('All Messages')
				  end
			  end.should change(Message, :count).by(1)
		  end

		  it 'should make a new message using mobile views on a mobile device' do
		    lambda do
		      VCR.use_cassette 'requests/message_activities/message_creation_success' do
		        visit new_message_path(:mobile => true)
		        fill_in 'Description', :with => 'Our customers were very happy!'
		        fill_in 'Location', :with => '20 Corlett Drive, Johannesburg'
		        select @group.name, :from => 'Group'
		        click_button 'Submit'
		        page.should have_selector('.mobile-heading-block', :content => 'All Tasks')
		      end
		    end.should change(Message, :count).by(1)
		  end
		end
	end

	describe 'Message editing' do
		before(:each) do
			VCR.use_cassette 'requests/message_activities/message_editing_creation' do
			  @message = FactoryGirl.create(:message, :user => @user, :group => @group)
			  visit edit_message_path(@message)
			end
		end

		describe 'failure' do
		  it 'should not update a edited message' do
		  	VCR.use_cassette 'requests/message_activities/message_editing_failure' do
			    fill_in 'Description', :with => ""
			    click_button 'Submit'
			    page.should have_selector('div.flash_error')
			    page.should have_content('Edit this Message')
			  end
		  end
		end

		describe 'success' do
		  it 'should update a edited message' do
		  	VCR.use_cassette 'requests/message_activities/message_editing_success' do
			    fill_in 'Description', :with => 'Our customers were not happy..'
			    fill_in 'Location', :with => '19 Corlett Drive, Johannesburg'
			    click_button 'Submit'
			    page.should have_content('All Messages')
			    page.should have_selector('tr.listing-item', :text => 'Our customers were not happy..')
			  end
		  end
		end
	end

	describe 'Message showing' do
	  it 'should show an message' do
	  	VCR.use_cassette 'requests/message_activities/message_show' do
		  	message = FactoryGirl.create(:message, :user => @user, :group => @group)
		    visit message_path(message)
		    page.should have_content('Message')
		    page.should have_selector('tr.listing-item', :text => message.description)
		  end
	  end
	end

	describe 'Message deleting' do
	  it 'should delete a message' do
	  	VCR.use_cassette 'requests/message_activities/message_delete' do
		  	message = FactoryGirl.create(:message, :user => @user, :group => @group)
		    visit message_path(message)
		    click_link 'Delete this Message'
		    page.should have_selector('div.flash_success', :text => 'Message removed.')
		  end
	  end
	end
end