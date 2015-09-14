class Api::V1::AndroidController < ApplicationController

  layout false

  skip_before_filter :check_access, :check_account_active, :check_payer, :prepare_for_mobile

  before_filter :api_authenticate

  def setup
    render json: {result_ok: true, types: @api_user.account.types, groups: @api_user.groups }
  end

  def create
    case params[:type]
    when 'event'
      params[:event][:priority_id] = @api_user.account.priorities.find_by(description: 'None').id
      params[:event][:status_id] = @api_user.account.statuses.find_by(description: 'None').id
      event = @api_user.incivents.create(params[:event])

      render json: {result_ok: true, event: event}
    when 'story'
      story = @api_user.stories.create(params[:story])

      render json: {result_ok: true, story: story}
    when 'measurement'
      measurement = @api_user.measurements.create(params[:measurement])

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
