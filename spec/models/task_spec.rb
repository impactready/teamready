require 'spec_helper'
require 'vcr'

describe Task do
  describe 'model_methods' do

    let(:user) { FactoryGirl.create(:user) }

    it 'checks deadlines for a looming task' do
      VCR.use_cassette 'requests/task_unit/task'do
        task = FactoryGirl.create(:task, due_date: 4.days.from_now, assigned_user_id: user.id)

        Task.check_deadlines

        ActionMailer::Base.deliveries.last.to.should include user.email
        ActionMailer::Base.deliveries.last.subject.should include 'will be due in 4 days'
      end
    end

    it 'checks deadlines for a due task' do
      VCR.use_cassette 'requests/task_unit/task' do
        task = FactoryGirl.create(:task, due_date: Date.today, assigned_user_id: user.id)

        Task.check_deadlines

        ActionMailer::Base.deliveries.last.to.should include user.email
        ActionMailer::Base.deliveries.last.subject.should include 'now due'
      end
    end
  end
end
