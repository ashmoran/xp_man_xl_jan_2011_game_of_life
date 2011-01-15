require 'spec_helper'
require 'game_of_life'

class Game
  def over?
    
  end
end

describe "GameOfLife" do
  let(:game) { Game.new }
  
  it "has all empty cells" do
    game.should be_over
  end
end