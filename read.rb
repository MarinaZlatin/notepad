# encoding: utf-8 Этот код только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT, STDERR].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'task.rb'
require_relative 'memo.rb'
require_relative 'tweet.rb'

# Входные параметры: id, limit, type

require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать (по умолчанию любой)') { |o| options[:type] = o } #
  opt.on('--id POST_ID', 'если задан id — показываем подробно только этот пост') { |o| options[:id] = o } #
  opt.on('--limit NUMBER', 'сколько последних постов показать (по умолчанию все)') { |o| options[:limit] = o } #

end.parse!

if options[:id].nil?
  result = Post.find_all(options[:limit], options[:type])
else
  result = Post.find_by_id(options[:id])
end

if result.is_a? Post # показываем конкретный пост
  puts "Запись #{result.class.name}, id = #{options[:id]}"
  # выведем весь пост на экран и закроемся
  result.to_strings.each do |line|
    puts line
  end

else # показываем таблицу результатов

  print "| id\t| @type\t|  @created_at\t\t\t|  @text \t\t\t| @url\t\t| @due_date \t "

  result.each do |row|
    puts
    # puts '_'*80
    row.each do |element|
      print "|  #{element.to_s.delete("\\n\\r")[0..40]}\t"
    end
  end
end

puts
