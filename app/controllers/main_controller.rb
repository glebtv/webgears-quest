class MainController < ApplicationController
  before_action :set_log, only: [:regexp_sort, :show, :update]
  before_action :set_logs

  def index
  end

  def create
    @log = Log.find_or_create_by(log_params)
    if @log.save
      redirect_to @log
      flash[:success] = 'save!'
    else
      redirect_to root_path
      flash[:error]  = 'Something goes wrong'
    end
  end

  def update
    @log.add_log_lines
    if @log.save
      redirect_to @log
      flash[:success] = 'Update!'
    end
  end

  def show
  end

  def regexp_sort
    @sort = Log.new
    @sort.log_lines = @log.regexp_search(params)
  end

  private
  def set_log
    @log = Log.find(params[:id])
  end

  def set_logs
    @logs = Log.all
  end

  def log_params
    params.require(:log).permit(:domain,:url)
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    params[:direction] || "asc"
  end
end
