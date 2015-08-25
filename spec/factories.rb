
FactoryGirl.define do

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
    usage 'Event type'
  end

  factory :type_indicator, class: Type do
    id 2
    description "Housing delivery"
    account_id 1
    usage 'Indicator'
  end

  factory :type_domain, class: Type do
    id 3
    description "Drug delivery frequency"
    account_id 1
    usage 'Domain of change'
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

  factory :measurement do
    description 'Household no. 12: Housing quality very good.'
    location '20 Corlett Drive, Johannesburg'
    group_id 1
    user_id 1
    type_id 2
    latitude 60.0
    longitude 70.0
  end

  factory :user do
    id 1
    first_name "Test"
    last_name "User"
    phone "27834455556"
    password "mememe"
    password_confirmation "mememe"
    account_id 1
    email "person1@example.com"
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
    id 1
    group_id 1
    detail "New story called 'Sort this out' created in group '#{FactoryGirl.build(:group).name}'."
    updatable_id 1
    updatable_type 'Story'
  end

  factory :membership do
    id 1
    user_id 1
    group_id 1
  end

  factory :incivent do
    id 1
    location '20 Corlett Drive, Johannesburg'
    sequence(:description) {|n| "It was bad...#{n}" }
    latitude 60.555
    longitude 70.333
    priority_id 1
    type_id 1
    status_id 1
    raised_user_id 1
    group_id 1
  end

  factory :task do
    id 1
    sequence(:description) {|n| "Do something - #{n}!" }
    location '20 Corlett Drive, Johannesburg'
    assigned_user_id 1
    group_id 1
    raised_user_id 1
    priority_id 1
    status_id 1
    due_date '2013-06-24'
    complete false
    latitude 60.0
    longitude 70.0
  end


  factory :story do
    id 1
    sequence(:description) {|n| "Sort this out...#{n}" }
    location '100 Corlett Drive, Johannesburg'
    user_id 1
    group_id 1
    type_id 3
    latitude 60.555
    longitude 70.333

  end

  factory :invitation do
    id 1
    account_id 1
    recipient_email 'person@example.com'
  end
end