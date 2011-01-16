require 'spec_helper'
require 'game_of_life'

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

describe "Game of Life" do
  let(:grid) { Grid.new(5, 5) }
  let(:game) { Game.new(grid) }
  
  it "plays a Blinker" do
    [[1, 2], [2, 2], [3, 2]].each do |x, y|
      game.make_alive(x, y)
    end
    
    game.grid_representation.should eq [
      [ false, false, false, false, false ],
      [ false, false, false, false, false ],
      [ false, true,  true,  true,  false ],
      [ false, false, false, false, false ],
      [ false, false, false, false, false ]
    ]
    
    game.start
    
    game.grid_representation.should eq [
      [ false, false, false, false, false ],
      [ false, false, true,  false, false ],
      [ false, false, true,  false, false ],
      [ false, false, true,  false, false ],
      [ false, false, false, false, false ]
    ]
    
    game.start
    
    game.grid_representation.should eq [
      [ false, false, false, false, false ],
      [ false, false, false, false, false ],
      [ false, true,  true,  true,  false ],
      [ false, false, false, false, false ],
      [ false, false, false, false, false ]
    ]
  end
end