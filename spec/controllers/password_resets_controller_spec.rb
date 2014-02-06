require 'spec_helper'

describe PasswordResetsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'reset'" do
    it "returns http success" do
      get 'reset'
      response.should be_success
    end
  end

end
