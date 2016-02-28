class Post

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def read_from_console         #   абстрактный метод реализуется в дочерних классах
    # чтение записей, введённых пользователем с консоли
    # todo
  end

  def to_strings                # абстрактный метод реализуется в дочерних классах
    # todo
  end

  def save
    # сохранение записи в файле
    file = File.new(file_path, "w:UTF-8") # создание нового файла

    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  def file_path             # не абстрактный метод
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name} %Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" + file_name
  end
end
