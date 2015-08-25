class ExportsController < ApplicationController
  require 'csv'

  def create
    params[:category][:group_object] = 'Incivent' if params[:category][:group_object] == 'Event'
    group = @current_user.groups.find_by(id: params[:category][:group_id])
    updates = group.updates.where(updatable_type: params[:category][:group_object])
    update_type = Update::TYPES.key(params[:category][:group_object].downcase)
    update_csv = CSV.generate do |csv|
      csv << Update.csv_column_headers(update_type)
      updates.each do |update|
        csv << update.csv_columns
      end
    end

    send_data update_csv, filename: "#{group.name.downcase.parameterize}_#{update_type}_#{Date.today}.csv"
  end
end