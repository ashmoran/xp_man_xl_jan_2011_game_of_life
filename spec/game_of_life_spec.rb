require 'spec_helper'
require 'game_of_life'

class Grid
  attr_reader :width, :height
  
  def initialize(width, height)
    @width = width
    @height = height
  end
end

describe "A 1x1 Grid" do
  let(:grid) { Grid.new(1, 1) }
  
  it "has width of 1" do
    grid.width.should eq 1
  end
  
  it "has height of 1" do
    grid.height.should eq 1
  end
  
  it "has one dead cell" do
    grid.cell_state(1, 1).should eq :dead
  end
end