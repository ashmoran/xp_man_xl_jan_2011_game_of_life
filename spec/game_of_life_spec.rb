require 'spec_helper'
require 'game_of_life'

class Cell
  ALIVE_EVOLUTION_FUNCTION = ->(number_of_neighbours) { number_of_neighbours == 2 || number_of_neighbours == 3 }
  
  def initialize(starts_alive)
    @alive = starts_alive
  end
  
  def evolve(number_of_neighbours)
    @alive = evolution_function[number_of_neighbours]
  end
  
  def alive?
    @alive
  end
  
  def evolution_function
    if @alive
      ALIVE_EVOLUTION_FUNCTION
    else
      ->(number_of_neighbours) { number_of_neighbours == 3 }
    end
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
    
    context "with 2 neighbours" do
      it "springs into life" do
        expect {
          cell.evolve(2)
        }.to_not change { cell.alive? }.from(false).to(true)
      end
    end
    
    context "with 3 neighbours" do
      it "springs into life" do
        expect {
          cell.evolve(3)
        }.to change { cell.alive? }.from(false).to(true)
      end
    end
  end
end
