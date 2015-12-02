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

      event = @api_user.incivents.new(
        description: params[:object][:description],
        type_id: type.id,
        group_id: group.id,
        priority_id: priority.id,
        status_id: status.id,
        longitude: params[:object][:longitude],
        latitude: params[:object][:latitude],
        incivent_image: params[:object][:image]
      )

      if event.save
        event.group.users.each do |user|
          begin
            Notification.notify_incivent(user, group, incivent_url(incivent)).deliver_now
          rescue Exception => e
            logger.error "Unable to deliver the event email: #{e.message}"
          end
        end
        group.updates_add_create('event', event)
        render json: {result_ok: true, event: event}
      else
        render json: {result_ok: false, event: nil}, status: 400
      end


    when 'story'
      story = @api_user.stories.new(
        description: params[:object][:description],
        type_id: type.id,
        group_id: group.id,
        longitude: params[:object][:longitude],
        latitude: params[:object][:latitude],
        story_image: params[:object][:image]
      )

      if story.save
        story.group.users.each do |user|
          begin
            Notification.notify_story(user, group, story_url(story)).deliver_now
          rescue Exception => e
            logger.error "Unable to deliver the story email: #{e.message}"
          end
        end
        group.updates_add_create('story', story)
        render json: {result_ok: true, story: story}
      else
        render json: {result_ok: false, story: nil}, status: 400
      end

    when 'measurement'
      measurement = @api_user.measurements.create(
        description: params[:object][:description],
        type_id: type.id,
        group_id: group.id,
        longitude: params[:object][:longitude],
        latitude: params[:object][:latitude],
        measurement_image: params[:object][:image]
      )

      if measurement.save
        measurement.group.users.each do |user|
          begin
            Notification.notify_measurement(user, group, measurement_url(measurement)).deliver_now
          rescue Exception => e
            logger.error "Unable to deliver the update email: #{e.message}"
          end
        end
        group.updates_add_create('measurement', measurement)
        render json: {result_ok: true, measurement: measurement}
      else
        render json: {result_ok: false, measurement: nil}, status: 400
      end
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
