
require 'sqlite3'


class Post

  @@SQLITE_DB_FILE = 'notepad.sqlite'

  def self.post_types
    {'Memo' => Memo, 'Link' => Link, 'Task' => Task, 'Tweet' => Tweet}
  end

  def self.create(type)
    return post_types[type].new
  end

  def self.find_by_id(id)
     db = SQLite3::Database.open(@@SQLITE_DB_FILE)

    # 1. Указан id: Запрос на конкретную запись
    if !id.nil?
      db.results_as_hash = true
      begin
        result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
      rescue SQLite3::Exception => e
        abort "Ошибка при запросе из базы данных #{@@SQLITE_DB_FILE}"
      end

      result = result[0] if result.is_a? Array
      if result.nil?
        puts "Такой id #{id} не найден в базе "
        return nil
      else
        post = create(result['type'])
        post.load_data(result)
        return post
      end
    end
    db.close
  end

  def self.find_all(limit, type)
    # 2. Вернуть таблицу записей
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
     db.results_as_hash = false

      # формируем запрос для получения всех записей
      query = "SELECT rowid, * FROM posts "

      query += "WHERE type = :type " unless type.nil? # если указан тип

      query += "order by rowid desc "  # сортировка по убыванию

      query += "limit :limit " unless limit.nil? # если задан лимит

      begin
        statement = db.prepare(query)
      rescue SQLite3::Exception => e
        abort "Ошибка при запросе из базы данных #{@@SQLITE_DB_FILE}"
      end
      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute!

      statement.close
      db.close

      return result

  end

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def read_from_console #   абстрактный метод реализуется в дочерних классах
    # чтение записей, введённых пользователем с консоли
    # todo
  end

  def to_strings # абстрактный метод реализуется в дочерних классах
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

  def file_path # не абстрактный метод
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name} %Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true

    db.execute("INSERT INTO posts (" +
              to_db_hash.keys.join(',') +
              ")" +
              " VALUES (" +
              ('?,'*to_db_hash.keys.size).chomp(',') +
              ")",
               to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    return insert_row_id
  end

  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end

  def load_data(data_hash)

    @created_at = Time.parse(data_hash['created_at'])
  end
end
