class TasksController < ApplicationController

  def index
    @tasks = current_user.relevant_tasks
  end

  def new
    @account = current_user.account
    @task = Task.new(raised_user_id: current_user.id)
    @users = @account.users
  end

  def show
    @account = current_user.account
    if (current_user.master_user? && current_user.account == Task.find(params[:id]).group.account) || @account.account_tasks.tasks_from_groups_joined_by(current_user).find_by(id: params[:id])
      @task = @account.account_tasks.find(params[:id])
    else
      deny_access_wrong_account
    end
  end

  def edit
    if (current_user.master_user? && current_user.account == Task.find(params[:id]).group.account) || Tasks.find_by(raised_user_id: current_user.id)
      @account = current_user.account
      @task = @account.account_tasks.find(params[:id])
      @group = @task.group
    else
      deny_access_wrong_account
    end
  end

  def create
    @account = current_user.account
    @task = Task.new(params[:task])
    group = @task.group
    @users = @account.users
    if @task.save
      begin
        Notification.notify_task(@task.user, group, task_url(@task)).deliver_now
      rescue Exception => e
        logger.error "Unable to deliver the task email: #{e.message}"
      end
      group.updates_add_create('task', @task)
      flash[:success] = 'Task created.'
      redirect_to tasks_path
    else
      flash[:error] = 'Task could not be created.'
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @task = @account.account_tasks.find(params[:id])
    group = @task.group
    if @task.update_attributes(params[:task])
      group.updates_add_complete(@task) if @task.complete == true
      flash[:success] = 'Task updated.'
      redirect_to tasks_path
    else
      flash[:error] = 'Task could not be updated.'
      render 'edit'
    end
  end

  def destroy
    account = current_user.account
    task = account.account_tasks.find(params[:id])
    group = task.group
    if task.update_attributes(archive: true)
      group.updates_add_delete('task', task)
      flash[:success] = 'Task removed.'
      redirect_to tasks_path
    end
  end

  def dynamic_users
    @group = Group.find(params[:user_id])
    @users = User.find(@group.user_ids)

    respond_to do |format|
      format.js
    end
  end

  def sort_index
    @tasks = current_user.relevant_tasks.order(params[:sort])

    respond_to do |format|
      format.js
    end
  end


end
