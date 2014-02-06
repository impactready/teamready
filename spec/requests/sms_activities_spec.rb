require 'spec_helper'

describe "SMS Activities" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @account = @user.account
    @priority = FactoryGirl.create(:priority, :account => @account)
    @status = FactoryGirl.create(:status, :account => @account)
    @type = FactoryGirl.create(:type, :account => @account)
    @group = FactoryGirl.create(:group, :account => @account)
    FactoryGirl.create(:membership, :user => @user, :group => @group)
  end

  describe "Inbound SMS Logging" do
    describe "Event/Message failure" do
      it "should not save an event/message with no details" do
        VCR.use_cassette 'requests/sms_activities/event_creation_failure' do
          json = {:result => 'Error'}.to_json
          get "/sms_ios/receive", :format => :json
          response.body.should == json
        end
      end

      it "should not save an event/message with wrong details" do
        VCR.use_cassette 'requests/sms_activities/event_creation_failure_2' do
          json = {:result => 'Error'}.to_json
          get "/sms_ios/receive?oa=#{@user.phone}&ud=Test", :format => :json
          response.body.should == json
        end
      end
    end

    describe "Event success" do
      it "should save an event with the correct details" do
        VCR.use_cassette 'requests/sms_activities/event_creation_success' do
          json = {:result => 'OK'}.to_json
          get "/sms_ios/receive?oa=#{@user.phone}&ud=Ev%2FDelivery+Trucks%2FOil+Spill%2F12+Kloof+Street+Cape+Town", :format => :json
          response.body.should == json
        end
      end
    end

    describe "Message success" do
      it "should save a message with the correct details" do
        VCR.use_cassette 'requests/sms_activities/message_creation_success' do
          json = {:result => 'OK'}.to_json
          get "/sms_ios/receive?oa=#{@user.phone}&ud=Ms%2FDelivery+Trucks%2FAll+fine+and+the+client+is+happy%2F30+Kloof+Street+Cape+Town", :format => :json
          response.body.should == json
        end
      end

      it "should save anything with the correct details as a message" do
        VCR.use_cassette 'requests/sms_activities/message_creation_success_2' do
          json = {:result => 'OK'}.to_json
          get "/sms_ios/receive?oa=#{@user.phone}&ud=XXX%2FDelivery+Trucks%2FAll+fine+and+the+client+is+happy%2F40+Kloof+Street+Cape+Town", :format => :json
          response.body.should == json
        end
      end
    end

  end

end