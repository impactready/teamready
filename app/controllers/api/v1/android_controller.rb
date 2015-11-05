class Api::V1::AndroidController < ApplicationController

  layout false

  skip_before_filter :check_access, :check_account_active, :check_payer, :prepare_for_mobile

  before_filter :api_authenticate

  def setup
    render json: {result_ok: true, types: @api_user.account.types, groups: @api_user.groups }
  end

  def create
    puts params

    type = @api_user.account.types.find_by(description: params[:object][:type])
    type ||= @api_user.account.types.find_by(description: 'None')
    group = @api_user.account.groups.find_by(description: params[:object][:group])
    group ||= @api_user.account.groups.first

    case params[:object_category]
    when 'event'
      priority = @api_user.account.priorities.find_by(description: 'None')
      status = @api_user.account.statuses.find_by(description: 'None')

      event = @api_user.incivents.create(
        description: params[:object][:description],
        type_id: type.id,
        group_id: group.id,
        priority_id: priority.id,
        status_id: status.id,
        longitude: params[:object][:longitude],
        latitude: params[:object][:latitude],
        incivent_image: params[:object][:image]
      )
      render json: {result_ok: true, event: event}
    when 'story'
      story = @api_user.stories.create(
        description: params[:object][:description],
        type_id: type.id,
        group_id: group.id,
        longitude: params[:object][:longitude],
        latitude: params[:object][:latitude],
        story_image: params[:object][:image]
      )

      render json: {result_ok: true, story: story}
    when 'measurement'
      measurement = @api_user.measurements.create(
        description: params[:object][:description],
        type_id: type.id,
        group_id: group.id,
        longitude: params[:object][:longitude],
        latitude: params[:object][:latitude],
        measurement_image: params[:object][:image]
      )

      render json: {result_ok: true, measurement: measurement}
    end

  end

  private

  def api_authenticate
    authenticate_or_request_with_http_basic do |u, p|
      @api_user = User.find_by(api_key: p)
      @api_user ? true : false
    end
  end
end
