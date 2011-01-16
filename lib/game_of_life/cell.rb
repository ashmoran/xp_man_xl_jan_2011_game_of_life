class Cell
  def initialize
    @state = :alive
  end
  
  def evolve(neighbours)
    @state = evolution_function[neighbours.count { |neighbour| neighbour.alive? } ] ? :alive : :dead
  end
    
  def become_alive
    @state = :alive
  end
  
  def alive?
    @state == :alive
  end
  
  private
  
  def evolution_function
    if @state == :alive
      ->(neighbours) { neighbours == 2 || neighbours == 3 }
    else
      ->(neighbours) { neighbours == 3 }
    end
  end
end
