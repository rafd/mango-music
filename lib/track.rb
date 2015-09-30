class Track
  attr_reader :id, :name, :artist, :plays

  def initialize(name, artist, plays=0, id=nil)
    @id = id.to_i
    @name = name
    @artist = artist
    @plays = plays.to_i
  end

  def listen!
    @plays+=1
  end

  def to_s
    "#{id}: #{name} by #{artist} (#{plays} listens)"
  end
end
