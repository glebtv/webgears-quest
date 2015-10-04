class Log < ActiveRecord::Base
  require 'open-uri'
  has_many :log_lines, dependent: :destroy

  after_create{
    uri = URI(self.glue)
    open(uri) do |f|
      f.each_line do |row|
        parse_log_line(row)
      end
    end
    self.save
  }

  def glue
    self.domain + self.url
  end


  def parse_log_line(row)
    self.log_lines.build(
      user_ip:         row.slice!(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}/),
      request_time:    row.slice!(/\[([^\]]+)\]/).gsub(/[\[\]]/, ''),
      request_content: row.slice!(/"([A-Z]+)[^"]*"/),
      response_status: row.slice!(/ \d+/),
      response_weight: row.slice!(/ \d+/),
      user_info:       row.slice!(/ "[^"]*" "([^"]*)"$/)
    )
  end

  def update_log_lines
    #
  end
end
