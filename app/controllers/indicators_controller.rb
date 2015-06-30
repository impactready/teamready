class IndicatorsController < ApplicationController

  before_filter :check_master_user

  def index
    @indicators = current_user.account.indicators
  end

  def new
    @account = current_user.account
    @indicator = @account.indicators.new
  end

  def edit
    @account = current_user.account
    @indicator = @account.indicators.find(params[:id])
  end

  def create
    @account = current_user.account
    @indicator = @account.indicators.build(params[:indicator])
    if @indicator.save
      flash[:success] = "Indicator created."
      redirect_to indicators_path
    else
      flash[:error] = "Indicator could not be created."
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @indicator = @account.indicators.find(params[:id])
    if @indicator.update_attributes(params[:indicator])
      flash[:success] = "Indicator updated."
      redirect_to indicators_path
    else
      flash[:error] = "Indicator could not be updated."
      render 'edit'
    end
  end

  def destroy
    indicators = Type.find(params[:id])
    indicators.destroy
    redirect_to indicators_path
  end

  private

  def check_master_user
    deny_access_master_user unless current_user.master_user?
  end

end