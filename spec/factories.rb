
FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :account_option do
    id 1
    name "Test"
    cost 0
    users 2
    groups 2
  end

  factory :account do
    id 1
    name "Environmental NGO"
    account_option_id 1
    active true
  end

  factory :type do
    id 1
    description "Environmental"
    account_id 1
  end

  factory :status do
    id 1
    description "Open"
    account_id 1
  end

  factory :priority do
    id 1
    description "High"
    account_id 1
  end

  factory :user do
    id 1
    first_name "Test"
    last_name "User"
    phone "27834455556"
    password "mememe"
    password_confirmation "mememe"
    account_id 1
    email { generate(:email) }
  end

  factory :group do
    id 1
    account_id 1
    name 'Cape Town'
    description 'All events in Cape Town'
    geo_info_file_name nil
    geo_info_content_type nil
    geo_info_file_size nil
    geo_info_updated_at nil
  end

  factory :update do
    group_id 1
    detail "New message called 'Sort this out' created in group '#{FactoryGirl.build(:group).name}'."
  end

  factory :membership do
    user_id 1
    group_id 1
  end

  factory :incivent do
    sequence(:name) {|n| "Oil Spill-#{n}" }
    location '20 Corlett Drive, Johannesburg'
    sequence(:description) {|n| "It was bad...#{n}" }
    latitude 60.555
    longitude 70.333
    priority_id 1
    type_id 1
    status_id 1
    user_id 1
    group_id 1
  end

  factory :task do
    sequence(:description) {|n| "Do something - #{n}!" }
    location '20 Corlett Drive, Johannesburg'
    user_id 1
    group_id 1
    raised_user_id 1
    priority_id 1
    status_id 1
    due_date '2013-06-24'
    complete false
    latitude 60.0
    longitude 70.0
  end


  factory :message do
    sequence(:description) {|n| "Sort this out...#{n}" }
    location '100 Corlett Drive, Johannesburg'
    user_id 1
    group_id 1
    latitude 60.555
    longitude 70.333

  end

  factory :invitation do
    account_id 1
    recipient_email 'person@example.com'
  end
end