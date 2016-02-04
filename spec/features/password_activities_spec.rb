require 'spec_helper'

describe 'Password Activities', type: :feature do
  before(:each) do
    FactoryGirl.create(:account)
    @user = FactoryGirl.create(:user)
  end

  it 'should reset the password and send an email' do
    visit new_password_reset_path
    fill_in 'Email', with: @user.email
    click_button 'Submit email'

    page.should have_content('Email sent with password reset instructions.')
    ActionMailer::Base.deliveries.last.to.should include @user.email
  end

end
