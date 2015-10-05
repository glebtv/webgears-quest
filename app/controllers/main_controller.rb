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
    @sort.log_lines = @log.log_lines.where(
        message(%w{user_ip request_time  request_content response_status response_weight user_info}),
        search_param('user_ip'),search_param('request_time'),search_param('request_content'),
        search_param('response_status') ,search_param('response_weight'), search_param('user_info')
    )
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
