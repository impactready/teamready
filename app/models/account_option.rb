class AccountOption < ActiveRecord::Base

  attr_accessible :name, :cost, :users, :groups

	has_many :accounts

	validates :name, presence: true
	validates :cost, presence: true

	before_save :cleanup

	def cleanup
	  self[:name] = self[:name].chomp
	end

end
