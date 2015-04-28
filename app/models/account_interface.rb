class AccountInterface

  def self.set_account_defaults(account)

    [ { description: "High"},
      { description: "Medium"},
      { description: "Low"}
    ].each do |priority|
      in_priority = account.priorities.build(priority)
      in_priority.save
    end


    [ { description: "Open"},
      { description: "Under Investigation"},
      { description: "Resolved",},
      { description: "Closed",}
    ].each do |status|
      in_status = account.statuses.build(status)
      in_status.save
    end


    [ { description: "Incident"},
      { description: "Meeting"},
      { description: "Visit"},
      { description: "Report Delivery"},
    ].each do |type|
      in_type = account.types.build(type)
      in_type.save
    end
  end
end
