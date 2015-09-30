class Fruit
  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Tropical < Fruit
  def initialize(name, color, delicious)
    super(name,color)
    @delicious = delicious
  end
end

a = Tropical.new("Mango", "Yellow", true)
puts a
