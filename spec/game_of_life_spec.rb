require 'spec_helper'
require 'game_of_life'

class Cell
  def initialize(starts_alive)
    @alive = starts_alive
  end
  
  def evolve(number_of_neighbours)
    @alive = [2, 3].include?(number_of_neighbours)
  end
  
  def alive?
    @alive
  end
end

describe "game_of_life" do
  let(:cell) { Cell.new(initial_alive_state) }
  
  describe "an alive", Cell do
    let(:initial_alive_state) { true }
    
    it "is alive" do
      cell.should be_alive
    end
    
    context "with 0 neighbours" do
      it "dies when it evolves" do
        cell.evolve(0)
        cell.should_not be_alive
      end
    end
    
    context "with 1 neighbour" do
      it "dies when it evolves" do
        cell.evolve(1)
        cell.should_not be_alive
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
        cell.evolve(4)
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
