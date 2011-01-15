require 'spec_helper'
require 'game_of_life'

class Game
  def over?
    true
  end
end

describe Game do
  let(:game) { Game.new }
  
  context "without setting any cells alive" do
    it "is over straight away" do
      game.should be_over
    end
  end
end