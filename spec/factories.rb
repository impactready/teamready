
FactoryGirl.define do

  factory :account_option do
    name "Test"
    cost 0
    users 2
    groups 2
  end

  factory :account do
    name "Environmental NGO"
    account_option
    active true
  end

  factory :type do
    description "Environmental"
    account
  end

  factory :status do
    description "Open"
    account
  end

  factory :priority do
    description "High"
    account
  end

  factory :user do
    first_name "Test"
    sequence(:last_name) {|n| "User#{n}" }
    phone "27834455556"
    password "mememe"
    password_confirmation "mememe"
    account
    sequence(:email) {|n| "person#{n}@example.com" }
  end

  factory :group do
    account
    name 'Cape Town'
    description 'All events in Cape Town'
    geo_info_file_name nil
    geo_info_content_type nil
    geo_info_file_size nil
    geo_info_updated_at nil
  end

  factory :update do
    group
    detail "New message called 'Sort this out' created in group '#{FactoryGirl.build(:group).name}'."
  end

  factory :membership do
    user
    group
  end

  factory :incivent do
    sequence(:name) {|n| "Oil Spill-#{n}" }
    location '20 Corlett Drive, Johannesburg'
    sequence(:description) {|n| "It was bad...#{n}" }
    latitude 60.555
    longitude 70.333
    priority
    type
    status
    user
    group
  end

  factory :task do
    sequence(:description) {|n| "Do something - #{n}!" }
    location '20 Corlett Drive, Johannesburg'
    user
    group
    raised_user_id 1
    priority
    status
    due_date '2013-06-24'
    complete false
    latitude 60.0
    longitude 70.0
  end


  factory :message do
    sequence(:description) {|n| "Sort this out...#{n}" }
    location '100 Corlett Drive, Johannesburg'
    user
    group
    latitude 60.555
    longitude 70.333

  end

  factory :invitation do
    account_id 1
    recipient_email 'person@example.com'
  end


end