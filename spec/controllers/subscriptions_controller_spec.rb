require 'spec_helper'

describe SubscriptionsController do

  before :each do
    @user = FactoryGirl.create :user
    subject.instance_variable_set :@current_user, @user
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'paypal_checkout'" do
    it "returns http success" do
      get 'paypal_checkout'
      response.should be_redirect
    end
  end

end
