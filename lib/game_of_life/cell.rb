class Cell
  def initialize
    @alive = false
  end
  
  def evolve(neighbours)
    @alive = evolution_function[neighbours.count { |neighbour| neighbour.alive? } ]
  end
    
  def become_alive
    @alive = true
  end
  
  def alive?
    @alive
  end
  
  private
  
  def evolution_function
    if @alive
      ->(neighbours) { neighbours == 2 || neighbours == 3 }
    else
      ->(neighbours) { neighbours == 3 }
    end
  end
end
