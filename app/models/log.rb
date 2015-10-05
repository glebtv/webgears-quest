class Log < ActiveRecord::Base
  has_many :log_lines, dependent: :destroy

  after_create{
    self.add_log_lines
  }

  def glue
    self.domain + self.url
  end

  def add_log_lines
    uri = URI(self.glue)
    download_log(uri)
    IO.readlines("tmp/buf_#{uri.host}").drop(self.log_lines_count).each do |row|
      self.parse_log_line(row)
      self.log_lines_count += 1
    end
    self.save
  end
  # Я полагал, что количество строк в лог-файле не уменьшается, тем самым, выполняя drop я отсекаю уже
  # добавленные логи.

  # Для экономии постоянной памяти, можно было бы не сохранять каждый отдельный лог в отдельный файл, а
  # написать метод преобразующий log_lines в исходный документ и затем его уже сравнивать с новыми логами

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

  def download_log(uri)
    system "wget -c #{uri} -O tmp/buf_#{uri.host}"
  end

end
