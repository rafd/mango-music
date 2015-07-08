require 'csv'

puts "Welcome to Mango Music"
puts "You can:"
puts "add <track> <artist>"
puts "listen <id of track>"
puts "list"
puts "search <search term>"
puts "quit"
puts ""
puts "What do now?"
input = gets.chomp

while input != "exit"
  case input.split(" ")[0]
  when "add"
    track_count = CSV.read("db.csv").length
    CSV.open("db.csv","ab") do |csv|
      csv << [track_count, input.split(" ")[1], input.split(" ")[2], 0]
    end
    puts "saved!"
  when "listen"
    id = input.split(" ")[1].to_i
    tracks = CSV.read("db.csv")
    puts "You're listening to... #{tracks[id][1]} by #{tracks[id][2]}"
    tracks[id][3] = tracks[id][3].to_i + 1
    CSV.open("db.csv", "wb") do |csv|
      tracks.each do |t|
        csv << t
      end
    end
  when "list"
    tracks = CSV.read("db.csv")
    tracks.each do |t|
      puts "#{t[0]}: #{t[1]} by #{t[2]} (#{t[3]} listens)"
    end
  when "search"
    tracks = []
    CSV.read("db.csv").each do |track|
      if /#{input.split(" ")[1]}/ =~ track[1]
        tracks << track
      elsif /#{input.split(" ")[1]}/ =~ track[2]
        tracks << track
      end
    end
    tracks.each do |t|
      puts "#{t[0]}: #{t[1]} by #{t[2]} (#{t[3]} listens)"
    end
  else
    puts "Huh?"
  end

  puts ""
  puts "What do now?"
  input = gets.chomp
end

puts ""
puts "Bye bye!"
