class Cell
  def initialize
    @state = :dead
  end
  
  EVOLVERS = {
    alive: ->(neighbours) { neighbours == 2 || neighbours == 3 },
    dead:  ->(neighbours) { neighbours == 3 }
  }
  
  def evolve(neighbours)
    @state = EVOLVERS[@state][neighbours.count { |neighbour| neighbour.alive? }]
  end
    
  def become_alive
    @state = :alive
  end
  
  def alive?
    @state == :alive
  end
end
