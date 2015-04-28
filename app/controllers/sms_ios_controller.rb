class SmsIosController < ApplicationController

  skip_before_filter :check_access, :check_account_active, :check_payer

	def receive
    # Example: Ms/Environmental/Toxic Spill!/12 Cresent St. Johannesburg
		if params[:ud] && params[:oa]
			if user = User.find_by_phone(params[:oa].gsub(/\D/, ''))
        account = user.account
      	model_att = params[:ud].split(%r{\s*/\s*}).collect(&:strip)
        if model_att.length == 4      
          SmsIo.save_inbound_details(user, account, model_att)
          SmsIo.send_sms(params[:od], "[Incivent] - Your message/event has been logged.")

          respond_to do |format|
            format.json { render json: {result: "OK"} }                
          end
        else  
          send_and_render_error
        end
      else
      	send_and_render_error
      end
    else
      send_and_render_error
		end
	end

  def send_and_render_error
    SmsIo.send_sms(params[:od], "[Incivent] - Number not recognized for submission.")

    respond_to do |format|
      format.json { render json: {result: "Error"} }            
    end
  end

end
