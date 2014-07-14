class LaunchInterest < ActiveRecord::Base

  attr_accessible :email_address, :message

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email_address, :presence => true,
                  :format => { :with => email_regex }
	validates :message, :presence => true

  default_scope -> { order(created_at: :desc) }

end
