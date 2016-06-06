class Memo < Post
  # если конструктор дочернего класса не написан,
  # то при создании дочернего класса будет вызываться конструктор родительского класса

  def read_from_console
    puts "Type note. Last line: end"

    @text = []
    line = nil

    while line != "end" do
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop    # удаление завершающего слова "end"
  end

  def to_strings
    time_string = "Created at #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return @text.unshift(time_string)
  end

  def  to_db_hash
    return super.merge(
        {
            'text' => @text.join('\n\r') # массив строк делаем одной большой строкой
        }
    )
  end

  def load_data(data_hash)
    super(data_hash) # обращение к родительскому методу

    @text = data_hash['text'].split('\n\r')
  end
end