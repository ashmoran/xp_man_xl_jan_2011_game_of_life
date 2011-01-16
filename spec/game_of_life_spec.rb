require 'spec_helper'

describe "Game of Life" do
  let(:grid) { Grid.new(5, 5) }
  let(:game) { Game.new(grid) }
  
  it "plays a Blinker" do
    [[1, 2], [2, 2], [3, 2]].each do |x, y|
      game.make_alive(x, y)
    end
    
    game.grid_representation.should eq [
      [ false, false, false, false, false ],
      [ false, false, false, false, false ],
      [ false, true,  true,  true,  false ],
      [ false, false, false, false, false ],
      [ false, false, false, false, false ]
    ]
    
    game.start
    
    game.grid_representation.should eq [
      [ false, false, false, false, false ],
      [ false, false, true,  false, false ],
      [ false, false, true,  false, false ],
      [ false, false, true,  false, false ],
      [ false, false, false, false, false ]
    ]
    
    game.start
    
    game.grid_representation.should eq [
      [ false, false, false, false, false ],
      [ false, false, false, false, false ],
      [ false, true,  true,  true,  false ],
      [ false, false, false, false, false ],
      [ false, false, false, false, false ]
    ]
  end
end