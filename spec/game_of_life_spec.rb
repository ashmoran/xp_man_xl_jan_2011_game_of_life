require 'spec_helper'
require 'game_of_life'

class Game
  def initialize(grid)
    @grid = grid
  end
  
  def make_alive(x, y)
    @grid.make_alive(x, y)
    nil
  end
  
  def over?
    @grid.all_cells_empty?
  end
  
  def grid_representation
    @grid.representation
  end
  
  def start
    @grid = @grid.evolve
  end
end

class Grid
  def initialize(width, height)
    @cells = (0...height).map { |x| (0...width).map { |y| Cell.new } }
  end
  
  def all_cells_empty?
    true
  end
  
  def make_alive(x, y)
    @cells[y][x].become_alive
  end
  
  def evolve
    Grid.clone_from_cells(@cells).tap do |new_grid|
      new_grid.evolve_from(self)
    end
  end
end

class Cell
  def initialize
    @alive = false
  end
  
  def evolve(number_of_neighbours)
    @alive = evolution_function[number_of_neighbours]
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

describe Cell do
  let(:cell) { Cell.new }
  
  it "is not alive when first created" do
    cell.should_not be_alive
  end
  
  describe "#become_alive" do
    it "makes the cell alive" do
      cell.become_alive
      cell.should be_alive
    end
  end
  
  # This code largely copied from the pairing session with Jimmbob
  describe "evolve" do
    context "a living cell" do
      before(:each) { cell.become_alive }
      
      context "with 0 neighbours" do
        it "dies when it evolves" do
          expect { cell.evolve(0) }.to change { cell.alive? }.from(true).to(false)
        end
      end

      context "with 1 neighbour" do
        it "dies when it evolves" do
          expect { cell.evolve(1) }.to change { cell.alive? }.from(true).to(false)
        end
      end

      context "with 2 neighbours" do
        it "stays alive when it evolves" do
          cell.evolve(2)
          cell.should be_alive
        end
      end

      context "with 3 neighbours" do
        it "stays alive when it evolves" do
          cell.evolve(3)
          cell.should be_alive
        end
      end

      context "with 4 neighbours" do
        it "dies when it evolves" do
          expect { cell.evolve(4) }.to change { cell.alive? }.from(true).to(false)
        end
      end
    end
    
    context "a dead cell" do
      context "with <=2 neighbours" do
        it "stays dead" do
          cell.evolve(2)
          cell.should_not be_alive
        end
      end

      context "with 3 neighbours" do
        it "springs into life" do
          expect {
            cell.evolve(3)
          }.to change { cell.alive? }.from(false).to(true)
        end
      end
      
      context "with >=4 neighbours" do
        it "stays dead" do
          cell.evolve(4)
          cell.should_not be_alive
        end
      end
    end
  end
end

describe Grid, "class" do
  describe "#new" do
    it "creates Cells" do
      Cell.should_receive(:new).exactly(6).times
      Grid.new(2, 3)
    end
  end
end

describe Grid do
  let(:cell_0_0) { mock("Cell (0,0)") }
  let(:cell_1_0) { mock("Cell (1,0)") }
  let(:cell_2_0) { mock("Cell (2,0)") }
  let(:cell_0_1) { mock("Cell (0,1)", become_alive: nil) }
  let(:cell_1_1) { mock("Cell (1,1)") }
  let(:cell_2_1) { mock("Cell (2,1)") }
  
  let(:cloned_grid) { mock("Cloned Grid", evolve_from: nil) }
  
  before(:each) do
    Grid.stub(clone_from_cells: cloned_grid)
    
    # We expect the Grid to treat the cells according to the order they are created
    Cell.stub(:new).and_return(cell_0_0, cell_1_0, cell_2_0, cell_0_1, cell_1_1, cell_2_1)
  end
  
  let(:grid) { Grid.new(3, 2) }

  it "should have all cells empty" do
    grid.all_cells_empty?.should be_true
  end
  
  describe "#make_alive" do
    it "makes a cell alive" do
      cell_1_0.should_receive(:become_alive)
      grid.make_alive(1, 0)
    end      
  end
  
  describe "#evolve" do
    it "clones the grid" do
      Grid.should_receive(:clone_from_cells).with(
        [[cell_0_0, cell_1_0, cell_2_0], [cell_0_1, cell_1_1, cell_2_1]]
      )
      grid.evolve
    end
    
    it "tells the cloned grid to evolve from the current state" do
      cloned_grid.should_receive(:evolve_from).with(grid)
      grid.evolve
    end
    
    it "returns the new grid" do
      grid.evolve.should eq cloned_grid
    end
  end
  
  describe "#evolve_from" do
    let(:reference_grid) { mock("Reference Grid", neighbours: [ :foo ]) }
    it "asks the reference grid for the neighbours of each cell" do
      reference_grid.should_receive(:neighbours).with(0, 0).and_return(:neighbours_of_0_0)
      reference_grid.should_receive(:neighbours).with(1, 0).and_return(:neighbours_of_1_0)
      reference_grid.should_receive(:neighbours).with(2, 0).and_return(:neighbours_of_2_0)
      reference_grid.should_receive(:neighbours).with(0, 1).and_return(:neighbours_of_0_1)
      reference_grid.should_receive(:neighbours).with(1, 1).and_return(:neighbours_of_1_1)
      reference_grid.should_receive(:neighbours).with(2, 1).and_return(:neighbours_of_2_1)
      grid.evolve_from(reference_grid)
    end
  end
end
  
describe Game, "with custom grid" do
  let(:grid) {
    mock(
      "Grid", 
      all_cells_empty?: true,
      make_alive: :ignored_value,
      representation: grid_representation,
      evolve: mock("Evolved Grid", representation: evolved_grid_representation)
    )
  }
  let(:grid_representation) { mock("grid_representation") }
  let(:evolved_grid_representation) { mock("evolved_grid_representation") }
  
  let(:game) { Game.new(grid) }
  
  describe "#over?" do
    it "is determined by whether the grid is empty" do
      grid.should_receive(:all_cells_empty?)
      game.over?
    end
    
    it "returns the status" do
      game.over?.should eq true
    end
  end
  
  describe "#make_alive" do
    it "tells the grid to make a cell alive" do
      grid.should_receive(:make_alive).with(1, 2)
      game.make_alive(1, 2)
    end
    
    it "returns nil" do
      game.make_alive(1, 2).should be_nil
    end
  end
  
  describe "#grid_representation" do
    it "gets the representation from the grid" do
      game.grid_representation.should eq grid_representation
    end
  end
  
  describe "#start" do
    it "evolves the grid" do
      grid.should_receive(:evolve)
      game.start
    end
    
    it "evolves the game state" do
      expect {
        game.start
      }.to change {
        game.grid_representation
      }.from(grid_representation).to(evolved_grid_representation)
    end
  end
end
