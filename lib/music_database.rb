require_relative 'database'

def track_array_to_hash(track)
  {id: track[0].to_i, title: track[1], artist: track[2], listen_count: track[3].to_i}
end

def track_to_s(t)
  t = track_array_to_hash(t)
 "#{t[:id]}: #{t[:title]} by #{t[:artist]} (#{t[:listen_count]} listens)"
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
  input = input_stream.gets.chomp.split(" ")
  database = Database.new(db_file)

  while input[0] != "exit"
    case input[0]
    when "add"
      title = input[1]
      artist = input[2]
      track_count = database.count
      database.add([track_count, title, artist, 0])
      output.puts "saved!"
    when "listen"
      title = input[1]
      tracks = database.all
      track = tracks.select do |t|
         t[1] == title
      end
      track = track[0]
      if track
        track = track_array_to_hash(track)
        output.puts "You're listening to... #{track[:title]} by #{track[:artist]}"
        tracks[track[:id]][3] = tracks[track[:id]][3].to_i + 1
        database.overwrite_all(tracks)
      end
    when "list"
      tracks = database.all
      tracks.each do |t|
        output.puts track_to_s(t)
      end
    when "search"
      query = input[1]
      tracks = []
      database.all.each do |track|
        track_hash = track_array_to_hash(track)
        if /#{query}/ =~ track_hash[:title]
          tracks << track
        elsif /#{query}/ =~ track_hash[:artist]
          tracks << track
        end
      end
      tracks.each do |t|
        output.puts track_to_s(t)
      end
    else
      output.puts "Huh?"
    end

    output.puts ""
    output.puts "What do now?"
    input = input_stream.gets.chomp.split(" ")
  end

  output.puts ""
  output.puts "Bye bye!"

end
