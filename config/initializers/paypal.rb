require "paypal/recurring"

PayPal::Recurring.configure do |config|
	if Rails.env.production?
		config.username = "raouldevilliers_api1.gmail.com"
		config.password = "UJBBU4S3Q9RQQ8SG"
		config.signature = "AfPByGHPs99-q2WQgLtrq5e4htXfAin5RAnm3CjX5yvMgPgizatb1V8D"
	else
		config.sandbox = true
		config.username = "seller_1343820800_biz_api1.gmail.com"
		config.password = "1343820868"
		config.signature = "AiPC9BjkCyDFQXbSkoZcgqH3hpacAOZBeKfUhSH.dl-fjBTFgp4eQRFL"
	end
end