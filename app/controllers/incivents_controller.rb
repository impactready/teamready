class InciventsController < ApplicationController

  def index
    @incivents = current_user.relevant_incivents(params[:search]).default_order
  end

  def new
    @account = current_user.account
    @incivent = current_user.incivents.new
  end

  def show
    @account = current_user.account
    if (current_user.master_user? && current_user.account == Incivent.find(params[:id]).group.account ) || @account.account_incivents.incivents_from_groups_joined_by(current_user).find_by(id: params[:id])
      @incivent = @account.account_incivents.find(params[:id])
    else
      deny_access_wrong_account
    end
  end

  def edit
    if (current_user.master_user? && current_user.account == Incivent.find(params[:id]).group.account ) || current_user.incivents.find_by(id: params[:id])
      @account = current_user.account
      @incivent = @account.account_incivents.find(params[:id])
    else
      deny_access_wrong_account
    end
  end

  def create
    @account = current_user.account
    @incivent = current_user.incivents.build(params[:incivent])
    group = @incivent.group
    if @incivent.save
      @incivent.group.users.each do |user|
        begin
          Notification.notify_incivent(user, group, incivent_url(@incivent)).deliver_now
        rescue Exception => e
          logger.error "Unable to deliver the event email: #{e.message}"
        end
      end
      group.updates_add_create('event', @incivent)
      flash[:success] = 'Event created!'
      mobile_device? ? redirect_to(tasks_path) : redirect_to(incivents_path)
    else
      flash[:error] = 'The event was not successfully created.'
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @incivent = @account.account_incivents.incivents_from_groups_joined_by(current_user).find(params[:id])
    group = @incivent.group
    if @incivent.update_attributes(params[:incivent])
      group.updates_add_archive('event', @incivent) if @incivent.archive == true
      flash[:success] = 'Event updated.'
      redirect_to incivents_path
    else
      flash[:error] = 'There were problems editing the event.'
      render 'edit'
    end
  end

  def destroy
    account = current_user.account
    incivent = account.account_incivents.find(params[:id])
    group = incivent.group
    if incivent.update_attributes(archive: true)
      group.updates_add_delete('event', incivent)
      flash[:success] = 'Event removed.'
      redirect_to incivents_path
    end
  end

  def sort_index
    @incivents = current_user.relevant_incivents(params[:search]).order(params[:sort])

    respond_to do |format|
      format.js
    end
  end

end
