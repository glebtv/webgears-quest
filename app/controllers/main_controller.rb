class MainController < ApplicationController
  def index
    @logs = Log.all
    @log  = Log.new
  end

  def create
    @log = Log.new(log_params)
    if @log.save
      redirect_to root_path
      flash[:success] = 'save!'
    end
  end

  private
  def log_params
    params.require(:log).permit(:domain,:url)
  end
end
