desc "These tasks are called by the Heroku scheduler add-on"

task :remind_intervention_due_date => :environment do
    Intervention.check_deadlines
end

# task :check_acc_still_pay => :environment do
#     Account.where(:payment_active => true, :active => true).each do |account|
#     	puts "Checking account #{account.id}..."
#     	ppr = account.subscription.sub_pp_recur_profile.profile
#     	puts "Done."
#     	unless ppr.active?
#     		account.update attributes(:payment_active => false, :active => false)
#     		puts "Account '#{account.name}' disabled."
#     	end
#     end
# end