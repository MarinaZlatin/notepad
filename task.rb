require 'date'

class Task < Post
  def initialize
    super

    @due_date = Time.now
  end

  def read_from_console
    puts "What is a task?"
    @text = STDIN.gets.chomp

    puts "Type the end date of the task. Format: dd.mm.yyyy"
    input = STDIN.gets.chomp

    @due_date = Date.parse(input)
  end

  def to_strings
    time_string = "Created at #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

     deadline = " Due date: #{@due_date}"

    return [deadline, @text, time_string]
  end
end