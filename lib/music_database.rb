require 'csv'

class Database
  def initialize(db_file)
    @db_file = db_file
  end

  def all
    CSV.read(@db_file)
  end

  def find
  end

  def add(arr)
    CSV.open(@db_file,"ab") do |csv|
      csv << arr
    end
  end

  def count
    CSV.read(@db_file).length
  end

  def overwrite_all(tracks)
    CSV.open(@db_file, "wb") do |csv|
      tracks.each do |t|
        csv << t
      end
    end
  end
end

def run(output, input_stream, db_file)
  output.puts "Welcome to Mango Music"
  output.puts "You can:"
  output.puts "add <track> <artist>"
  output.puts "listen <id of track>"
  output.puts "list"
  output.puts "search <search term>"
  output.puts "quit"
  output.puts ""
  output.puts "What do now?"
  input = input_stream.gets.chomp
  database = Database.new(db_file)

  while input != "exit"
    case input.split(" ")[0]
    when "add"
      track_count = database.count
      database.add([track_count, input.split(" ")[1], input.split(" ")[2], 0])
      output.puts "saved!"
    when "listen"
      title = input.split(" ")[1]
      tracks = database.all
      track = tracks.select do |t|
         t[1] == title
      end
      track = track[0]
      if track
        output.puts "You're listening to... #{track[1]} by #{track[2]}"
        tracks[track[0].to_i][3] = tracks[track[0].to_i][3].to_i + 1
        database.overwrite_all(tracks)
      end
    when "list"
      tracks = database.all
      tracks.each do |t|
        output.puts "#{t[0]}: #{t[1]} by #{t[2]} (#{t[3]} listens)"
      end
    when "search"
      tracks = []
      database.all.each do |track|
        if /#{input.split(" ")[1]}/ =~ track[1]
          tracks << track
        elsif /#{input.split(" ")[1]}/ =~ track[2]
          tracks << track
        end
      end
      tracks.each do |t|
        output.puts "#{t[0]}: #{t[1]} by #{t[2]} (#{t[3]} listens)"
      end
    else
      output.puts "Huh?"
    end

    output.puts ""
    output.puts "What do now?"
    input = input_stream.gets.chomp
  end

  output.puts ""
  output.puts "Bye bye!"

end
