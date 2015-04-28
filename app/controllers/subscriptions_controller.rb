class SubscriptionsController < ApplicationController

  skip_before_filter :check_payer

  def new
    redirect_to groups_path if current_user.account.payment_active
  end

  def activate
    @activation_code = params[:activation][:code]
    if @activation_code.match(/\A[a-z][1-9][A-Z]+[a-z]{3}[1-9]+[a-z]\z/)
      if current_user.master_user
        account = current_user.account
        account.toggle(:payment_active)
        account.save
        flash[:success] = 'Your account is now active.'
        redirect_to groups_path
      end
    else
      flash[:error] = 'The activation code is not valid.'
      render 'new'
    end
  end

  # This section is for paypal integration, which is not active view for the 'new' action would
  # redirect to the paypal_checkout action below. Currently payment is invoice only.

  # def paypal_checkout
  #   @account = current_user.account
  #   if @account.subscription
  #     @account.subscription.cancel_pp_subscription
  #     @account.subscription.destroy
  #   end
  # 	response = Subscription.sub_pp_checkout(@account, finalise_subscriptions_url, root_url).checkout
  # 	if response.valid?
		# 	redirect_to response.checkout_url
		# else
		# 	Subscription.check_paypal_response(response)
		# end
  # end

  # def finalise
  # 	@account = current_user.account
  #   @subscription = @account.build_subscription(paypal_token: params[:token], paypal_payer_token: params[:PayerID])
  # 	response = @subscription.sub_pp_payment(@account).request_payment
 	# 	Subscription.check_paypal_response(response)
 	# 	response = @subscription.sub_pp_recurring(@account).create_recurring_profile
  #   Subscription.check_paypal_response(response)
		# @subscription.recurring_profile_token = response.profile_id
		# @subscription.save!
		# @account.payment_active = true
		# @account.save!
  #   flash[:success] = "Payment successful! You can now start using your account"
		# redirect_to groups_path
  # end

end
