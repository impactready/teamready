require 'spec_helper'

describe 'Static Page Activities' do
	describe 'get the Home Page' do
	  it "should show details from the home page" do
	    visit '/'
	    page.should have_content('SEE YOUR ORGANISATION PERFORMING')
	    page.should have_selector('div.photo-main')
	  end
	end

	describe 'get the Pricing Page' do
	  it "should show details from the home page" do
	    visit '/pricing'
	    page.should have_content('Pricing')
	    page.should have_selector('div.pricing')
	  end
	end

	describe 'get the Contact Page' do
	  it "should show details from the home page" do
	    visit '/contact'
	    page.should have_content('Want to know more?')
	  end
	end

	describe 'fill in the Contact Page' do

	  before(:each) do
	    visit '/contact'
	  end

	  it "should not accept an empty form" do
	    click_button 'Submit'
	    page.should have_selector('div.flash_error')
	  end

	  it "should accept a valid form" do
	    fill_in 'Contact Email', :with => 'raoul@example.com'
	    fill_in 'Message', :with => 'Hi! I am interested in your site...'
	    click_button 'Submit'
	    page.should have_selector('div.flash_success')
	  end

	end

end