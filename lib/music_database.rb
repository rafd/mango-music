require_relative 'mango'

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
  mango = Mango.new(db_file)

  commands = input_stream.gets.chomp.split(" ")

  while commands[0] != "exit"
    case commands[0]
    when "add"
      _, name, artist = commands
      mango.add(name,artist)
      output.puts "saved!"
    when "listen"
      title = commands[1]
      track = mango.find_by_title(title)
      if track
        output.puts "You're listening to... #{track.name} by #{track.artist}"
        track.listen!
        mango.update(track)
      end
    when "list"
      tracks = mango.all
      tracks.each do |t|
        output.puts t.to_s
      end
    when "search"
      query = commands[1]
      tracks = mango.search(query)
      tracks.each do |t|
        output.puts t.to_s
      end
    else
      output.puts "Huh?"
    end

    output.puts ""
    output.puts "What do now?"
    commands = input_stream.gets.chomp.split(" ")
  end

  output.puts ""
  output.puts "Bye bye!"

end
