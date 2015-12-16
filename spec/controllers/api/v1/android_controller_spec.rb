require 'spec_helper'

describe Api::V1::AndroidController do
  before(:each) do
    user = FactoryGirl.create(:user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('api',user.api_key)
  end

  describe "GET 'statuses'" do
    it "returns status objects for a user" do
      FactoryGirl.create(:account)
      type = FactoryGirl.create(:type)
      FactoryGirl.create(:group)

      get 'setup'
      body = JSON.parse(response.body)

      expect(response).to be_success
      expect(body["types"][0]["description"]).to eq "Environmental"
    end

    it "returns nothing if the user is not authenticated" do
      request.env['HTTP_AUTHORIZATION'] = nil

      get 'setup'

      expect(response).not_to be_success
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
        post 'create', object_category: 'event', object: { description: "Serious Oil Spill", type: @type.description, group: @group.name, longitude: "28.0878431", latitude: "-26.1249014" }

        body = JSON.parse(response.body)
        expect(response).to be_success
        expect(body['event']['description']).to eq('Serious Oil Spill')
        expect(ActionMailer::Base.deliveries.last.subject).to include "A new event"
      end
    end

    it "does not create an event if there is something missing" do
      post 'create', object_category: 'event', object: { description: nil, type: @type.description, group: @group.name, longitude: nil, latitude: nil}

      body = JSON.parse(response.body)
      expect(response).to be_success
      expect(body['event']).to eq(nil)
    end

    it "creates a story via the API" do
      VCR.use_cassette 'controllers/api_controller/story_creation_success' do
        post 'create', object_category: 'story', object: { description: "Our customers were very happy!", type: @type.description, group: @group.name, longitude: "28.0878431", latitude: "-26.1249014" }

        body = JSON.parse(response.body)
        expect(response).to be_success
        expect(body['story']['description']).to eq('Our customers were very happy!')
        expect(ActionMailer::Base.deliveries.last.subject).to include "A new story"
      end
    end

    it "creates a measurement via the API" do
      VCR.use_cassette 'controllers/api_controller/measurement_creation_success' do
        post 'create', object_category: 'measurement', object: { description: "Delivery is up by 100%.", type: @type.description, group: @group.name, longitude: "28.0878431", latitude: "-26.1249014" }

        body = JSON.parse(response.body)
        expect(response).to be_success
        expect(body['measurement']['description']).to eq('Delivery is up by 100%.')
        expect(ActionMailer::Base.deliveries.last.subject).to include "A new indicator measurement"
      end
    end
  end

end
