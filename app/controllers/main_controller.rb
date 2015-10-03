class MainController < ApplicationController
  before_action :set_log, only: [:regexp_sort,:show]
  before_action :set_logs

  def index

  end

  def create
    @log = Log.new(log_params)
    if @log.save
      redirect_to @log
      flash[:success] = 'save!'
    end
  end

  def show
  end

  def regexp_sort
    #@sort = Log.includes(:log_lines).find(:all,{ params[:id], log_lines:{user_ip: params[:user_ip]}})
      @sort = Log.new
     
      @sort.log_lines = @log.log_lines.where(
          message(%w{user_ip request_time  request_content response_status response_weight user_info}),
          search_param('user_ip'),search_param('request_time'),search_param('request_content'),
          search_param('response_status') ,search_param('response_weight'), search_param('user_info')
      )

     #@sort = @sort.where("request_content ~ ?", params[:regexp_request_content])
     #@sort.where("request_time ~ ?",    params[:regexp_request_time]) if params[:regexp_request_time].present?
     #@sort.where("response_status ~ ?", params[:regexp_response_status])  if params[:regexp_response_status].present?
     #@sort = @sort.where("response_weight ~ ?", params[:regexp_response_weight]) if params[:regexp_response_weight].present?= @sort.where("user_info ~ ?",     params[:regexp_user_info])if params[:regexp_user_info].present?
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
