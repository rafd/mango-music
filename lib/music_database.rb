require_relative 'database'

def track_array_to_hash(track)
  {id: track[0].to_i, title: track[1], artist: track[2]}
end

def track_to_s(t)
 "#{t[0]}: #{t[1]} by #{t[2]} (#{t[3]} listens)"
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
      tracks = []
      database.all.each do |track|
        if /#{input.split(" ")[1]}/ =~ track[1]
          tracks << track
        elsif /#{input.split(" ")[1]}/ =~ track[2]
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
    input = input_stream.gets.chomp
  end

  output.puts ""
  output.puts "Bye bye!"

end
