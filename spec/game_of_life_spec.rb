require 'spec_helper'
require 'game_of_life'

class Game
  def initialize
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