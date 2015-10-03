class LogLine < ActiveRecord::Base
  belongs_to :log

  scope :search, ->(params) {message(params)}



end
