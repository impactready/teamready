class SmsIo < ActiveRecord::Base

	def self.send_sms(string, phone_no)
		url = URI.parse('http://client.connet-systems.com/submit/')
		post_args = {
			'username' => 'worldwize',
			'password' => 'vae0aih5Bayerau',
			'account' => 'worldwize',
		  'da' => phone_no,
		  'ud' => string,
		  'id' => rand(36**10).to_s(36)
		}
		return response = Net::HTTP.post_form(url, post_args).body
	end

	def self.save_inbound_details(user, account, model_att)
	  group = account.groups.where("name LIKE ? OR description LIKE?", "#{model_att[1].chomp.titlecase}", "#{model_att[1].chomp.titlecase}").first
		if model_att[0].titlecase.match("Ev")
			user.incivents.create!( group: group.nil? ? account.groups.where(name: "SMS Inbound", description: "SMS Inbound").first_or_create(name: "SMS Inbound", description: "SMS Inbound") : group,
	                           name: model_att[2].chomp,
	                           description: model_att[2].chomp,
	                           location: model_att[3].chomp,
	                           status_id: account.statuses.first.id,
	                           type_id: account.types.first.id,
	                           priority_id: account.priorities.first.id )
	  else
	    user.messages.create!( group: group.nil? ? account.groups.where(name: "SMS Inbound", description: "SMS Inbound").first_or_create(name: "SMS Inbound", description: "SMS Inbound") : group,
	                          description: model_att[2].chomp,
	                          location: model_att[3].chomp )
		end
	end

end
