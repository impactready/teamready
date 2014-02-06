module StaticPagesHelper

	def account_option_param(string)
		new_account_path + "?" + {:account_option => string }.to_param
	end

end