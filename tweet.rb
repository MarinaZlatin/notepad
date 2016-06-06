# Твитер

require 'twitter'

class Tweet < Post

  @@CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key = 'uydK17gE2UjWleJoMv32KNazT'
    config.consumer_secret = 'BgRwrUsl3lcfPbFlfoet1K5O9ym4q5SSBrq7taS49qgZ7mdKmY'
    config.access_token = '66168814-izlrdyDhpyTGoV2xR1hYs9xhNWHsYQ99kDIhoieSS'
    config.access_token_secret = '98W7QBY7i5DSoOqTaYrA4pMWLbCG51ofYS88xKU6tNfnq'
  end

  def read_from_console
    puts "Введите новое сообщение, не более 140 символов"

    @text = STDIN.gets.chomp[0..140]

    puts "Отправляем ваше сообщение: #{@text.encode('utf-8')}"

    @@CLIENT.update(@text.encode('utf-8'))

    puts "Сообщение отправлено"
  end

  def to_strings
    time_string = "Created at #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return @text.unshift(time_string)
  end

  def  to_db_hash
    return super.merge(
        {
            'text' => @text
        }
    )
  end

  def load_data(data_hash)
    super(data_hash) # обращение к родительскому методу

    @text = data_hash['text'].split('\n\r')
  end
end