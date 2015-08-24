class ExportsController < ApplicationController
  require 'csv'

  def create
    objects = @current_user.groups.find_by(params[:group_id]).send(params[:class].down_case.pluralize.to_sym)
    object_csv = CSV.generate do |csv|
      csv << params[:class].contantize.csv_column_headers
      objects.each do |object|
        csv << object.csv_columns
      end
    end

    send_data @report.to_csv, filename: "pastel_recon_#{@report.recon_type.downcase}_#{Date.today}.csv"
  end
end