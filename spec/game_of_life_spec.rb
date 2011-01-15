require 'spec_helper'
require 'game_of_life'

class Cell
  def initialize(starts_alive)
    @alive = starts_alive
  end
  
  def evolve(number_of_neighbours)
    @alive = false
  end
  
  def alive?
    @alive
  end
end

describe "game_of_life" do
  let(:cell) { Cell.new(initial_alive_state) }
  
  describe "an alive", Cell do
    # let(:cell) { Cell.new(true) }
    let(:initial_alive_state) { true }
    
    it "is alive" do
      cell.should be_alive
    end
    
    context "with less than 2 neighbour" do
      it "dies when it evolves" do
        cell.evolve(0)
        cell.should_not be_alive
      end      
    end
  end
  
  describe "a dead", Cell do
    let(:initial_alive_state) { false }
    
    it "is dead" do
      cell.should_not be_alive
    end
  end
end
