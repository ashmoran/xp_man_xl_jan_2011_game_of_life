class Cell
  def initialize
    become :dead
  end
  
  EVOLVERS = {
    alive: ->(neighbours) { :dead unless neighbours == 2 || neighbours == 3 },
    dead:  ->(neighbours) { :alive if neighbours == 3 }
  }
  
  def evolve(neighbours)
    become new_state(neighbours)
  end
    
  def become_alive
    become :alive
  end
  
  def alive?
    @state == :alive
  end
  
  private
  
  def become(state)
    return unless state
    @state = state
    @evolver = EVOLVERS[state]
  end
  
  def new_state(neighbours)
    @evolver[number_of_living(neighbours)]
  end
  
  def number_of_living(neighbours)
    neighbours.count { |neighbour| neighbour.alive? }
  end
end
