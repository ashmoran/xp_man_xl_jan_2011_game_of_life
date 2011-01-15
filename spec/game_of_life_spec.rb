require 'spec_helper'
require 'game_of_life'

class Cell
  def initialize
  end
  
  def alive?
    true
  end
end

describe "game_of_life" do
  describe "an alive", Cell do
    it "is alive" do
      Cell.new(true).should be_alive
    end
  end
  
  describe "a dead", Cell do
    it "is dead" do
      Cell.new(false).should_not be_alive
    end
  end
end
