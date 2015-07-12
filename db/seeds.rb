# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Setting account options..."

[	{ name: "Test", cost: 0, users: 2, groups: 1},
	{ name: "Pro", cost: 129, users: 20, groups: 10},
	{ name: "Enterprise", cost: 199, users: 9999, groups: 9999}
].each do |account_option|
	AccountOption.create!(account_option)
 end

puts "Setting account..."

Account.create({ id: 1, name: "ImpactReady", account_option_id: 1, active: true })

puts "Setting priorities..."

[	{ description: "High"},
	{ description: "Medium"},
	{ description: "Low"}
].each do |priority|
	in_priority = Account.find(1).priorities.build(priority)
	in_priority.save!
end

puts "Setting statuses..."

[	{ description: "Open", account_id: 1 },
	{ description: "Under Investigation", account_id: 1 },
	{ description: "Resolved",  account_id: 1 },
	{ description: "Closed",  account_id: 1 }
].each do |status|
	in_status = Account.find(1).statuses.build(status)
	in_status.save!
end

puts "Setting types..."

[	{ description: "Delivery delay", account_id: 1, usage: 'Event category' },
	{ description: "Stock spoilage", account_id: 1, usage: 'Measurement indicator' }
].each do |type|
	in_type = Account.find(1).types.build(type)
	in_type.save!
end

puts "Creating users..."

[	{ first_name: "Joseph", last_name: "Barnes", email: "joseph@impactready.org",
	password: "mememe", password_confirmation: "mememe"},
	{ first_name: "Raoul", last_name: "de Villiers", email: "raoul@world-wize.com",
	password: "mememe", password_confirmation: "mememe"}
].each do |user|
	in_account = Account.find(1)
	in_user = in_account.users.build(user)
	if in_user.full_name == "Raoul de Villiers" || "Joseph Barnes"
		in_user.toggle(:master_user)
		in_user.toggle(:admin_user)
	end
	in_user.save!
 end

puts "Populating groups..."

[	{ name: "Delivery Trucks", description: "A group for all our delivery trucks." }
].each do |group|
	in_group = Account.find(1).groups.build(group)
	in_group.save!
end

puts "Populating memberships..."

[	{ group_id: 1 }
].each do |membership|
	in_membership = User.find(1).memberships.build(membership)
	in_membership = User.find(2).memberships.build(membership)
	in_membership.save!
end


puts "Populating events..."

[	{ name: "Tire Burst on my van!", raised_user_id: 1, location: "174 Longmarket St, Cape Town 8000, South Africa",
	priority_id: 1, type_id: 1, description: "I burst a tire and I will not be on time!", group_id: 1, status_id: 1 }
].each do |incivent|
	in_civent = User.find(1).incivents.build(incivent)
	in_civent.save!
end

puts "Populating tasks..."

[	{ description: "Deliver 4 packages to SDS", location: "0 Darling St, Cape Town 8000, South Africa", group_id: 1,
	assigned_user_id: 1, priority_id: 1, status_id: 1, raised_user_id: 1, due_date: '2012-06-15' },
	{ description: "Deliver new Steinway piano to international meistro", location: "23 Lion St, Cape Town 8001, South Africa", group_id: 1,
	assigned_user_id: 2, priority_id: 2, status_id: 1, raised_user_id: 1, due_date: '2012-06-15' }
].each do |task|
	Task.create!(task)
end

puts "Populating messages..."

[	{ description: "Customer raved about us! I am on my way to the next delivery.", group_id: 1, type_id: 2, location: "Strand St, Cape Town 8001, South Africa" }
].each do |story|
	in_message = User.find(1).stories.build(story)
	in_message.save!
end

