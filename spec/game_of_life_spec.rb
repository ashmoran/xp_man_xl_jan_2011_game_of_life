require 'spec_helper'
require 'game_of_life'

class Game
  def initialize(grid)
    @over = true
    @grid = grid
  end
  
  def make_alive(x, y)
    @grid.make_alive(x, y)
    nil
  end
  
  def over?
    @grid.all_cells_empty?
  end
end

describe Game, pending: true do
  let(:game) { Game.new }
  
  context "without setting any cells alive" do
    it "is over straight away" do
      game.should be_over
    end
  end
  
  context "after setting one cell alive" do
    it "is not over straight away" do
      game.make_alive(1, 1)
      game.should_not be_over
    end
  end
end
  
describe Game, "with custom grid" do
  let(:grid) { mock("Grid", all_cells_empty?: true, make_alive: :unimportant) }
  let(:game) { Game.new(grid) }
  
  describe "over?" do
    it "is determined by whether the grid is empty" do
      grid.should_receive(:all_cells_empty?)
      game.over?
    end
    
    it "returns the status" do
      game.over?.should eq true
    end
  end
  
  describe "make_alive" do
    it "tells the grid to make a cell alive" do
      grid.should_receive(:make_alive).with(1, 2)
      game.make_alive(1, 2)
    end
    
    it "returns nil" do
      game.make_alive(1, 2).should be_nil
    end
  end
end
