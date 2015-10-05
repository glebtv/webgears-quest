class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :new_log

  def new_log
    @new_log  = Log.new
  end

  def message(params)
    message = ''
    params.map do |p|
      message += " #{p} ~ ? AND"
    end
    message[0..-4]
  end


  def search_param(param)
      params[param.to_sym].blank? ? '.*' : params[param.to_sym]
  end


end
