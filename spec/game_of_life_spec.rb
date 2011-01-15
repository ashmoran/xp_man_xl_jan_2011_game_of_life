require 'spec_helper'
require 'game_of_life'

class Grid
  attr_reader :width, :height
  
  def initialize(width, height)
    @width = width
    @height = height
    @cell_state = :dead
    @cell_states = Hash.new(:dead)
  end
  
  def cell_state(x, y)
    @cell_states[[x, y]]
    # @cell_state
  end
  
  def make_alive(x, y)
    @cell_states = :alive
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
  
  context "after setting a cell to alive" do
    it "has one live cell" do
      grid.make_alive(1, 1)
      grid.cell_state(1, 1).should eq :alive
    end
  end
end

describe "A 2x2 Grid" do
  let(:grid) { Grid.new(2, 2) }
  
  it "has all dead cells" do
    grid.cell_state(1,1).should eq :dead
    grid.cell_state(1,2).should eq :dead
    grid.cell_state(2,1).should eq :dead
    grid.cell_state(2,2).should eq :dead
  end
  
  
  context "after setting a cell to alive" do
    it "has one live cell" do
      grid.make_alive(1, 2)
      grid.cell_state(1, 2).should eq :alive
      grid.cell_state(1,1).should eq :dead
      grid.cell_state(2,1).should eq :dead
      grid.cell_state(2,2).should eq :dead      
    end
  end
end