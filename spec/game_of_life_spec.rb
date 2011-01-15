require 'spec_helper'
require 'game_of_life'

class Grid
  def initialize(width, height)
    @width = width
  end
  
  def width
    @width
  end
end

describe "A 1x1 Grid" do
  it "has width of 1" do
    Grid.new(1, 1).width.should eq 1
  end
end