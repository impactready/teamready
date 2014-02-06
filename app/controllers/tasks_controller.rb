class TasksController < ApplicationController

  def index
    @tasks = current_user.relevant_tasks
  end

  def new
    @account = current_user.account
    @task = Task.new(:raised_user_id => current_user.id)
    @users = @account.users.all
  end

  def bulk_new
    @account = current_user.account
    @group = @account.groups.find(params[:group_id])
    10.times { @group.tasks.new(:raised_user_id => current_user.id) }
    @users = @account.users.all
  end

  def edit
    @account = current_user.account
    @task = @account.account_tasks.find(params[:id])
    @group = @task.group
  end

  def show
    @account = current_user.account
    @task = @account.account_tasks.find(params[:id])
  end

  def create
    @account = current_user.account
    @task = Task.new(params[:task])
    group = @task.group
    @users = @account.users.all
    if @task.save
      Notification.notify_task(@task.user, group, task_url(@task)).deliver rescue logger.error 'Unable to deliver the task email.'
      group.updates_add_create(group.name, 'task', @task.description)
      flash[:success] = 'Task created.'
      redirect_to tasks_path
    else
      flash[:error] = 'Task could not be created.'
      render 'new'
    end
  end

  def bulk_create
    @account = current_user.account
    @group = @account.groups.find(params[:group_id])
    params[:group][:tasks_attributes].delete_if {|key, value| value[:description] == '' || value[:location] == '' || value[:due_date] == ''}
    if @group.update_attributes!(params[:group])
      flash[:success] = 'Group tasks created.'
      redirect_to groups_path
    else
      flash[:error] = 'Group tasks could not be created.'
      render 'bulk_new'
    end
  end

  def update
    @account = current_user.account
    @task = @account.account_tasks.find(params[:id])
    group = @task.group
    if @task.update_attributes(params[:task])
      group.updates_add_complete(group.name, @task.description) if @task.complete == true
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
    if task.destroy
      group.updates_add_delete(group.name, 'task', task.description)
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
