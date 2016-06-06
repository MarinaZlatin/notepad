class Link < Post   #  объявление дочернего класса, родитель Post

  def initialize
    super   # подключение метода с таким же названием из родительского класса

    @url = ''
  end

  def read_from_console
    puts "Address of link"
    @url = STDIN.gets.chomp

    puts "Description of link"
    @text = STDIN.gets.chomp

  end

  def to_strings
    time_string = "Created at #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return [@url, @text, time_string]
  end

  def  to_db_hash
    return super.merge(
        {
            'text' => @text,
            'url' => @url
        }
    )
  end

  def load_data(data_hash)
    super(data_hash) # обращение к родительскому методу

    @url = data_hash['url']
  end
end