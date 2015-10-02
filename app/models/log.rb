class Log < ActiveRecord::Base
  require 'net/http'
  has_many :log_lines, dependent: :destroy

  after_create{
    uri = URI(self.glue)
    rows = Net::HTTP.get(uri).split(/[\n]/)
    rows.each do |row|
      parse_log_line(row)
    end

    self.save
  }

  def glue
    self.domain + self.url
  end

  def dateTime_from(row)
    date = row.slice!(/\[([^\]]+)\]/)
    date[date.index(':')] = ' '
    DateTime.parse(date.to_s)
  end

  def parse_log_line(row)
    self.log_lines.build(
      user_ip: row.slice!(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}/),
      request_time: dateTime_from(row),
      request_content: row.slice!(/"([A-Z]+)[^"]*"/),
      response_status: row.slice!(/ \d+/),
      response_weight: row.slice!(/ \d+/),
      user_info: row.slice!(/ "[^"]*" "([^"]*)"$/)
    )
  end

end
