class Account < ActiveRecord::Base
	attr_accessible :name, :account_option_id
	attr_protected :id

	belongs_to :account_option

	has_many :users, dependent: :destroy
	has_many :groups, dependent: :destroy
	has_many :priorities, dependent: :destroy
	has_many :types, dependent: :destroy
	has_many :statuses, dependent: :destroy
	has_one :subscription, dependent: :destroy

	validates :name, presence: true
	validates :account_option_id, presence: true, numericality:  { only_integer: true }

	def account_incivents
		account_group_ids = self.group_ids
		return Incivent.where(group_id: account_group_ids)
	end

	def account_tasks
		account_group_ids = self.group_ids
		return Task.where(group_id: account_group_ids)
	end

	def account_messages
		account_group_ids = self.group_ids
		return Message.where(group_id: account_group_ids)
	end


end
