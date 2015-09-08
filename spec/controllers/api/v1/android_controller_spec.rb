require 'spec_helper'

describe Api::V1::AndroidController do
  before(:each) do
    user = FactoryGirl.create(:user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('api',user.api_key)
  end

  describe "GET 'statuses'" do
    it "creates an event" do
      FactoryGirl.create(:account)
      FactoryGirl.create(:type)
      FactoryGirl.create(:group)

      get 'setup'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    before(:each) do
      FactoryGirl.create(:account)
      @type = FactoryGirl.create(:type)
      @group = FactoryGirl.create(:group)
      FactoryGirl.create(:membership)
      FactoryGirl.create(:status, description: 'None')
      FactoryGirl.create(:priority, description: 'None')
    end

    it "creates an event via the API" do
      VCR.use_cassette 'controllers/api_controller/event_creation_success' do
        post 'create', type: 'event', event: { description: 'Serious Oil Spill', type_id: @type.id, group_id: @group.id, longitude: 28.0878431, latitude: -26.1249014}

        body = JSON.parse(response.body)
        response.should be_success
        expect(body['event']['description']).to eq('Serious Oil Spill')
      end
    end

    it "creates a story via the API" do
      VCR.use_cassette 'controllers/api_controller/story_creation_success' do
        post 'create', type: 'story', story: { description: 'Our customers were very happy!', type_id: @type.id, group_id: @group.id, longitude: 28.0878431, latitude: -26.1249014}

        body = JSON.parse(response.body)
        response.should be_success
        expect(body['story']['description']).to eq('Our customers were very happy!')
      end
    end

    it "creates a measurement via the API" do
      VCR.use_cassette 'controllers/api_controller/measurement_creation_success' do
        post 'create', type: 'measurement', measurement: { description: 'Delivery is up by 100%.', type_id: @type.id, group_id: @group.id, longitude: 28.0878431, latitude: -26.1249014}

        body = JSON.parse(response.body)
        response.should be_success
        expect(body['measurement']['description']).to eq('Delivery is up by 100%.')
      end
    end
  end

end
