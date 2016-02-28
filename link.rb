class Link < Post   #  объявление дочернего класса, родитель Post

  def initialize
    super   # подключение метода с таким же названием из родительского класса

    @url = ''
  end

  def read_from_console

  end

  def to_strings

  end

end