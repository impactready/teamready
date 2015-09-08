class AccountInterface

  def self.set_account_defaults(account)

    [ { description: "None"}
    ].each do |priority|
      in_priority = account.priorities.build(priority)
      in_priority.save
    end


    [ { description: "None"}
    ].each do |status|
      in_status = account.statuses.build(status)
      in_status.save
    end


    [ { description: "None", usage: Type::USAGES[:event_type]},
      { description: "None", usage: Type::USAGES[:indicator]},
      { description: "None", usage: Type::USAGES[:domain_of_change]},
    ].each do |type|
      in_type = account.types.build(type)
      in_type.save
    end
  end
end
