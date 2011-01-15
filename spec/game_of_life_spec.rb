require 'spec_helper'
require 'game_of_life'

describe "game_of_life" do
  describe "a cell with fewer than 2 neighbours" do
    it "dies" do
      pending      
      cell.evolve
      cell.should be_alive
    end
  end
end