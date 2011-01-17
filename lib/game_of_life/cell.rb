class Cell
  def initialize
    @state = :dead
  end
  
  EVOLVERS = {
    alive: ->(neighbours) { :dead unless neighbours == 2 || neighbours == 3 },
    dead:  ->(neighbours) { :alive if neighbours == 3 }
  }
  
  def evolve(neighbours)
    @state = (new_state(neighbours) or return)
  end
    
  def become_alive
    @state = :alive
  end
  
  def alive?
    @state == :alive
  end
  
  private
  
  def new_state(neighbours)
    EVOLVERS[@state][number_of_living(neighbours)]
  end
  
  def number_of_living(neighbours)
    neighbours.count { |neighbour| neighbour.alive? }
  end
end
