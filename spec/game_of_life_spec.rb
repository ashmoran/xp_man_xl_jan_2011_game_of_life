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
    (width * height).times do
      Cell.new
    end
  end
  
  def all_cells_empty?
    true
  end
end

class Cell
  
end

describe Grid, "class" do
  describe "#new" do
    it "creates Cells" do
      Cell.should_receive(:new).exactly(4).times
      Grid.new
    end
  end
end

describe Grid do
  let(:grid) { Grid.new(2, 2) }

  it "should have all cells empty" do
    grid.all_cells_empty?.should be_true
  end
  
  describe "#make_alive" do
    it "makes a cell alive" do
      pending
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
