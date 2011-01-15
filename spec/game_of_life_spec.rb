require 'spec_helper'
require 'game_of_life'

class Game
  def initialize(grid)
    @over = true
  end
  
  def make_alive(*)
    @over = false
  end
  
  def over?
    @over
  end
end

describe Game do
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
  let(:grid) { mock("Grid") }
  let(:game) { Game.new(grid) }
  
  describe "over?" do
    it "is determined by whether the grid is empty" do
      grid.should_receive(:all_cells_empty?)
      game.over?
    end
  end
end
