class Grid
  attr_reader :width, :height
  
  class << self
    def clone_from(reference_grid)
      new(reference_grid.width, reference_grid.height).tap do |new_grid|
        new_grid.update_from_representation(reference_grid.representation)  
      end
    end
  end
  
  def initialize(width, height)
    @width, @height = width, height
    @cells = generate_cells
  end
  
  def all_cells_empty?
    true
  end
  
  def neighbours(x, y)
    [ ].tap do |cell_neighbours|
      neighbour_points(x, y).each do |neighbour_x, neighbour_y|
        neighbour_point = Point.new(neighbour_x, neighbour_y)
        collect_cell(cell_neighbours, neighbour_point)
      end      
    end
  end
  
  def neighbour_points(x, y)
    [
      [x - 1, y - 1],
      [x - 1, y],
      [x - 1, y + 1],
      [x, y - 1],
      [x, y + 1],
      [x + 1, y - 1],
      [x + 1, y],
      [x + 1, y + 1]
    ]
  end
  
  def make_alive(x, y)
    @cells[y][x].become_alive
  end
  
  def evolve
    Grid.clone_from(self).tap do |new_grid|
      new_grid.evolve_from(self)
    end
  end
  
  def evolve_from(reference_grid)
    each_cell { |cell, x, y| cell.evolve(reference_grid.neighbours(x, y)) }
  end
  
  def representation
    @cells.map { |row| row.map { |cell| cell.alive? } }
  end
  
  def update_from_representation(representation)
    each_cell { |cell, x, y| cell.become_alive if representation[y][x] }
  end
  
  private
  
  def each_cell
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        yield(cell, x, y)
      end      
    end
  end
  
  def generate_cells
    (0...@height).map {
      (0...@width).map {
        Cell.new
      }
    }
  end
  
  class Point < Struct.new(:x, :y)
    def exists_within?(width, height)
      (0 ... width).include?(x) && (0 ... height).include?(y)
    end
  end
  
  def valid_point?(point)
    point.exists_within?(width, height)
  end
  
  def collect_cell(collection, point)
    collection << @cells[point.y][point.x] if valid_point?(point)
  end
end
