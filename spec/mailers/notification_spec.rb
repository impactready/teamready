require "spec_helper"


describe "Notifications" do 

  let(:testuser) { FactoryGirl.create(:user) }
  let(:testincivent) { FactoryGirl.create(:incivent) }
  let(:testgroup) { FactoryGirl.create(:group) }
  let(:testaction) { FactoryGirl.create(:intervention) }

  describe "notify_incivent" do
    let(:mail) { Notification.notify_incivent(testuser, testgroup, incivent_url(testincivent)) }

    it "renders the headers" do
      mail.subject.should include("A new incivent has been created in the group")
      mail.to.should match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      mail.from.should eq("noreply@incivent.com")
    end

    it "renders the body" do
      mail.body.encoded.should include("A new incivent has been added in the group")
    end
  end

  describe "notify_intervention" do
    let(:mail) { Notification.notify_intervention(testuser, testincivent, incivents_url) }

    it "renders the headers" do
      mail.subject.should include("a new action has been assigned to you in the group")
      mail.to.should match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      mail.from.should eq("noreply@incivent.com")
    end

    it "renders the body" do
      mail.body.encoded.should include("A new action has been assigned to you in the group")
    end
  end

  describe "notify_deadline" do
    let(:mail) { Notification.notify_deadline(testuser, testaction.description) }

    it "renders the headers" do
      mail.subject.should include("an action which has been assigned to you on the Incivent platform is now due")
      mail.to.should match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      mail.from.should eq("noreply@incivent.com")
    end

    it "renders the body" do
      mail.body.encoded.should include("is due today!")
    end
  end

  describe "notify_looming" do
    let(:mail) { Notification.notify_looming(testuser, testaction.description) }

    it "renders the headers" do
      mail.subject.should include("an action which has been assigned to you on the Incivent platform will be due in 4 days")
      mail.to.should match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      mail.from.should eq("noreply@incivent.com")
    end

    it "renders the body" do
      mail.body.encoded.should include("is due in 4 days.")
    end
  end
end
