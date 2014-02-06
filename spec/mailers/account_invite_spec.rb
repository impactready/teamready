require "spec_helper"

describe 'AccountInvite' do

  let(:testinvite) { FactoryGirl.create(:invitation) }

  describe "invitation" do
    let(:mail) { AccountInvite.invitation }

    it "renders the headers" do
      mail.subject.should eq("[Incivent Platform] - Invitation to register")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["noreply@incivent.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("User Registration - Incivent platform")
    end
  end

end
