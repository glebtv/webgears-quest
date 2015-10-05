class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :new_log

  def new_log
    @new_log  = Log.new
  end

end
