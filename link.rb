class Link < Post   #  объявление дочернего класса, родитель Post

  def initialize
    super   # подключение метода с таким же названием из родительского класса

    @url = ''
  end

  def read_from_console
    puts "Address of link"
    @url = STDIN.gets.chomp

    puts "Description jf link"
    @text = STDIN.gets.chomp

  end

  def to_strings
    time_string = "Created at #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return [@url, @text, time_string]
  end

end