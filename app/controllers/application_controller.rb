class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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
