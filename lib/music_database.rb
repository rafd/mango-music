require 'csv'

class Database
  def initialize(db_file)
    @db_file = db_file
  end

  def count
    CSV.read(@db_file).length
  end

  def add(data)
    CSV.open(@db_file,"ab") do |csv|
      data[0] = $. # $. is current line number
      csv << data
    end
  end

  def all
    CSV.read(@db_file)
  end

  def replace(data)
    CSV.open(@db_file, "wb") do |csv|
      data.each do |t|
        csv << t
      end
    end
  end

  def update(arr)
    # TODO: can make more efficient
    id = arr[0]
    records = self.all
    records[id] = arr
    self.replace(records)
  end
end

class Track
  attr_reader :id, :name, :artist, :plays

  def initialize(name, artist, plays=0, id=nil)
    @id = id.to_i
    @name = name
    @artist = artist
    @plays = plays.to_i
  end

  def listen
    @plays+=1
  end
end

def track_to_array(track)
  [track.id, track.name, track.artist, track.plays]
end

def array_to_track(arr)
  Track.new(arr[1],arr[2],arr[3],arr[0])
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
  db = Database.new(db_file)

  while input != "exit"
    case input.split(" ")[0]
    when "add"
      _, name, artist = input.split(" ")
      db.add(track_to_array(Track.new(name, artist)))
      output.puts "saved!"
    when "listen"
      title = input.split(" ")[1]
      tracks = db.all.map {|arr| array_to_track(arr) }
      track = tracks.find do |t|
         t.name == title
      end
      if track
        output.puts "You're listening to... #{track.name} by #{track.artist}"
        track.listen
        db.update(track_to_array(track))
      end
    when "list"
      tracks = db.all
      tracks.each do |t|
        output.puts "#{t[0]}: #{t[1]} by #{t[2]} (#{t[3]} listens)"
      end
    when "search"
      tracks = []
      db.all.each do |track|
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
