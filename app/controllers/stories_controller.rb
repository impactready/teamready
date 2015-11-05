class StoriesController < ApplicationController

  def index
    @stories = current_user.relevant_stories.default_order
  end

  def new
    @account = current_user.account
    @story = current_user.stories.new
  end

  def edit
    @account = current_user.account
    @story = @account.account_stories.find(params[:id])
  end

  def show
    @account = current_user.account
    @story = @account.account_stories.find(params[:id])
  end

  def create
    @account = current_user.account
    @story = current_user.stories.build(params[:story])
    group = @story.group
    if @story.save
      @story.group.users.each do |user|
        begin
          Notification.notify_story(user, group, story_url(@story)).deliver_now
        rescue Exception => e
          logger.error "Unable to deliver the story email: #{e.message}"
        end
      end
      group.updates_add_create('story', @story)
      flash[:success] = 'Story added!'
      mobile_device? ? redirect_to(tasks_path) : redirect_to(stories_path)
    else
      flash[:error] = 'The story was not successfully added.'
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @story = @account.account_stories.find(params[:id])
    group = @story.group
    if @story.update_attributes(params[:story])
      group.updates_add_archive('story', @story) if @story.archive == true
      flash[:success] = 'Story updated.'
      redirect_to stories_path
    else
      flash[:error] = 'There was a problem editing the story.'
      render 'edit'
    end
  end

  def destroy
    account = current_user.account
    story = account.account_stories.find(params[:id])
    group = story.group
    if story.update_attributes(archive: true)
      group.updates_add_delete('story', story)
      flash[:success] = 'Story removed.'
      redirect_to stories_path
    end
  end

  def sort_index
    @stories = current_user.relevant_stories.order(params[:sort])

    respond_to do |format|
      format.js
    end
  end

end
