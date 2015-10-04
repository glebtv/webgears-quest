class Log < ActiveRecord::Base
  has_many :log_lines, dependent: :destroy

  require 'net/http'

  after_create{
    uri = URI(self.glue)
    download_log(uri)
    IO.readlines('tmp/buf').each do |row|
      self.parse_log_line(row)
    end
  }



  after_update{
    #self.update_log_lines
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
    ################
  end


  def download_log(uri)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      http.request request do |response|
        open 'tmp/buf', 'w' do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end

end
