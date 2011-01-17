class Cell
  def initialize
    @state = :dead
  end
  
  EVOLVERS = {
    alive: ->(neighbours) { :dead if neighbours == 2 || neighbours == 3},
    dead:  ->(neighbours) { :alive if neighbours == 3 }
  }
  
  def evolve(neighbours)
    @state = EVOLVERS[@state][neighbours.count { |neighbour| neighbour.alive? }] or return
  end
    
  def become_alive
    @state = :alive
  end
  
  def alive?
    @state == :alive
  end
end
