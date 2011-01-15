require 'spec_helper'
require 'game_of_life'

class Cell
  def initialize(starts_alive)
    @alive = starts_alive
  end
  
  def evolve
    @alive = false
  end
  
  def alive?
    @alive
  end
end

describe "game_of_life" do
  describe "an alive", Cell do
    it "is alive" do
      Cell.new(true).should be_alive
    end
    
    context "with less than 2 neighbour" do
      it "dies when it evolves" do
        cell = Cell.new(true)
        cell.evolve(0)
        cell.should_not be_alive
      end      
    end
  end
  
  describe "a dead", Cell do
    it "is dead" do
      Cell.new(false).should_not be_alive
    end
  end
end
