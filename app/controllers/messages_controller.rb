class MessagesController < ApplicationController

  def index
    @messages = current_user.relevant_messages.default_order
  end

  def new
    @message = current_user.messages.new
  end

  def edit
    @account = current_user.account
    @message = @account.account_messages.find(params[:id])
  end

  def show
    @account = current_user.account
    @message = @account.account_messages.find(params[:id])
  end

  def create
    @message = current_user.messages.build(params[:message])
    group = @message.group
    if @message.save
      Notification.notify_message(user, group, message_url(@message)).deliver rescue logger.error 'Unable to deliver the message email.'
      group.updates_add_create(group.name, 'message', @message.description)
      flash[:success] = 'Message added!'
      mobile_device? ? redirect_to(tasks_path) : redirect_to(messages_path)
    else
      flash[:error] = 'The message was not successfully added.'
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @message = @account.account_messages.find(params[:id])
    group = @message.group
    if @message.update_attributes(params[:message])
      group.updates_add_archive(group.name, 'message', @message.description) if @message.archive == true
      flash[:success] = 'Message updated.'
      redirect_to messages_path
    else
      flash[:error] = 'There was a problem editing the message.'
      render 'edit'
    end
  end

  def destroy
    account = current_user.account
    message = account.account_messages.find(params[:id])
    group = message.group
    if message.destroy
      group.updates_add_delete(group.name, 'message', message.description)
      flash[:success] = 'Message removed.'
      redirect_to messages_path
    end
  end

  def sort_index
    @messages = current_user.relevant_messages.order(params[:sort])

    respond_to do |format|
      format.js
    end
  end

end
