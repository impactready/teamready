require 'spec_helper'

RSpec.describe ExportsController, type: :controller do

  describe 'REST' do

    it "submits a form for an event and then creates the csv export" do
      VCR.use_cassette 'controllers/exports_controller/create_incivent' do
        user = FactoryGirl.create(:user)
        cookies[:auth_token] = user.auth_token

       FactoryGirl.create(:account_option)
       FactoryGirl.create(:account)
        group = FactoryGirl.create(:group)
        FactoryGirl.create(:membership)
        FactoryGirl.create(:type)
        FactoryGirl.create(:status)
        FactoryGirl.create(:priority)
        event = FactoryGirl.create(:incivent)
        update = FactoryGirl.create(:update, updatable_id: event.id, updatable_type: 'Incivent', detail: 'Testing 1')

        post :create, category: {group_object: 'Event', group_id: group.id}

        expect(response).to be_success
        expect(response.body).to include event.description
        expect(response.body).to include update.detail
      end
    end

    it "submits a form for an event and then creates the csv export" do
      VCR.use_cassette 'controllers/exports_controller/create_task' do
        user = FactoryGirl.create(:user)
        cookies[:auth_token] = user.auth_token

       FactoryGirl.create(:account_option)
       FactoryGirl.create(:account)
        group = FactoryGirl.create(:group)
        FactoryGirl.create(:membership)
        FactoryGirl.create(:status)
        FactoryGirl.create(:priority)
        task = FactoryGirl.create(:task)
        update = FactoryGirl.create(:update, updatable_id: task.id, updatable_type: 'Task', detail: 'Testing 1')

        post :create, category: {group_object: 'Task', group_id: group.id}

        expect(response).to be_success
        expect(response.body).to include task.description
        expect(response.body).to include update.detail
      end
    end
  end
end
