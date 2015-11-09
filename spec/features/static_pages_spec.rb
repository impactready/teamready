require 'spec_helper'

describe 'Static Page Activities' do
	describe 'get the Home Page' do
	  it "should show details from the home page" do
	    visit '/'
	    page.should have_content('AN IMMERSIVE REPORTING TOOL')
	  end
	end

	describe 'get the Pricing Page' do
	  it "should show details from the pricing page" do
	    visit '/pricing'
	    page.should have_content('Signup')
	    page.should have_selector('div.pricing')
	  end

	  it "should show details from the pricing page and click through to the contact page" do
	    visit '/pricing'
	    page.should have_content('Signup')
	    page.should have_selector('div.pricing')

	    click_button 'New account'

	    page.should have_content 'Contact us'
	    page.should have_content 'Thank you for your interest in joining us.'
	  end
	end

	describe 'get the Contact Page' do
	  it "should show details from the home page" do
	    visit '/contact'
	    page.should have_content('Want to discuss our offering?')
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
	    fill_in 'Contact Email', with: 'raoul@example.com'
	    fill_in 'Message', with: 'Hi! I am interested in your site...'
	    click_button 'Submit'
	    page.should have_selector('div.flash_success')
	    ActionMailer::Base.deliveries.last.to.should include 'joseph@impactready.org'
	  end

	end

end