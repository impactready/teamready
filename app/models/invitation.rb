class Invitation < ActiveRecord::Base

	attr_accessible :recipient_email, :account_id

	validate :recipient_is_not_registered
	validates :recipient_email, presence: true

	before_create :generate_token

	def downcase_email_and_save
		self.recipient_email = self.recipient_email.downcase
		save
	end

	private

	def recipient_is_not_registered
	  errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
	end

	def generate_token
	  self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
	end


end
