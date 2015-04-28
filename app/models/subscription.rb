class Subscription < ActiveRecord::Base
  attr_accessible :paypal_payer_token, :recurring_profile_token, :paypal_token
  attr_accessor :paypal_token

  belongs_to :account

  validates :paypal_payer_token, :recurring_profile_token, :account_id,	 presence: true

	def self.sub_pp_checkout(account, return_url, cancel_url)
	  PayPal::Recurring.new(
			return_url: return_url,
			 cancel_url: cancel_url,
			 description: "[Incivent Platform] - Account name: #{account.name} - Account option: #{account.account_option.name} - Cost: #{account.account_option.cost}",
			 amount: account.account_option.cost,
			 currency: "USD"
	  	)
	end

	def sub_pp_payment(account)
		PayPal::Recurring.new(
		  token: paypal_token,
		  payer_id: paypal_payer_token,
		  amount: account.account_option.cost,
			description: "[Incivent Platform] - Account name: #{account.name} - Account option: #{account.account_option.name} - Cost: #{account.account_option.cost}",
		)
	end

	def sub_pp_recurring(account)
		PayPal::Recurring.new(
			token: paypal_token,
		  payer_id: paypal_payer_token,
		  amount: account.account_option.cost,
		  description: "[Incivent Platform] - Account name: #{account.name} - Account option: #{account.account_option.name} - Cost: #{account.account_option.cost}",
		  period: :monthly,
		  frequency: 1,
		  start_at:  Time.zone.now
		)
	end

	def update_pp_recurring(account)
		PayPal::Recurring.new(
			profile_id: recurring_profile_token,
		  amount: account.account_option.cost,
		  description: "#{account.name} -- #{account.account_option.name} -- #{account.account_option.cost}",
		  note: "Changed plan to #{account.account_option.name}",
		  outstanding: :next_billing,
		  start_at:  Time.zone.now
		)
	end

	def sub_pp_recur_profile
	 	PayPal::Recurring.new(
		  profile_id: recurring_profile_token
		)
	end

	def self.check_paypal_response(response)
    if response.errors.any?
        raise response.errors.inspect
    end
  end

  def remove__pp_subscription
  	sub_pp_recur_profile.ppr.cancel
  end
  
end
