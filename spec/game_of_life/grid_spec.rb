require 'spec_helper'

describe Grid, "class" do
  describe "#new" do
    it "creates Cells" do
      Cell.should_receive(:new).exactly(6).times
      Grid.new(2, 3)
    end
  end
  
  describe "#clone_from" do
    let(:reference_grid_representation) { mock("Reference Grid Representation") }
    let(:reference_grid) {
      mock(Grid, width: 3, height: 2, representation: reference_grid_representation)
    }
    let(:new_grid) { mock(Grid, update_from_representation: nil) }
    
    before(:each) do
      Grid.stub(new: new_grid)
    end
    
    it "creates a new grid" do
      Grid.should_receive(:new).with(3, 2).and_return(new_grid)
      Grid.clone_from(reference_grid)
    end
    
    it "updates the new grid" do
      new_grid.should_receive(:update_from_representation).with(reference_grid_representation)
      Grid.clone_from(reference_grid)
    end
    
    it "returns the new grid" do
      Grid.clone_from(reference_grid).should eq new_grid
    end
  end
end

describe Grid do
  let(:cell_0_0) { mock("Cell (0,0)", alive?: false) }
  let(:cell_1_0) { mock("Cell (1,0)", alive?: false) }
  let(:cell_2_0) { mock("Cell (2,0)", alive?: false) }
  let(:cell_0_1) { mock("Cell (0,1)", alive?: false, become_alive: nil) }
  let(:cell_1_1) { mock("Cell (1,1)", alive?: false) }
  let(:cell_2_1) { mock("Cell (2,1)", alive?: false) }
  
  let(:cloned_grid) { mock("Cloned Grid", evolve_from: nil) }
  
  before(:each) do
    Grid.stub(clone_from: cloned_grid)
    
    # We expect the Grid to treat the cells according to the order they are created
    Cell.stub(:new).and_return(cell_0_0, cell_1_0, cell_2_0, cell_0_1, cell_1_1, cell_2_1)
  end
  
  let(:grid) { Grid.new(3, 2) }

  it "should have all cells empty" do
    grid.all_cells_empty?.should be_true
  end
  
  describe "#width" do
    it "returns the width" do
      grid.width.should eq 3
    end
  end
  
  describe "#height" do
    it "returns the height" do
      grid.height.should eq 2
    end
  end
  
  describe "#make_alive" do
    it "makes a cell alive" do
      cell_1_0.should_receive(:become_alive)
      grid.make_alive(1, 0)
    end      
  end
  
  describe "#evolve" do
    it "clones the grid" do
      Grid.should_receive(:clone_from).with(grid)
      grid.evolve
    end
    
    it "tells the cloned grid to evolve from the current state" do
      cloned_grid.should_receive(:evolve_from).with(grid)
      grid.evolve
    end
    
    it "returns the new grid" do
      grid.evolve.should eq cloned_grid
    end
  end
  
  describe "#neighbours" do
    it "returns neighbours of the top-left corner" do
      grid.neighbours(0, 0).should =~ [ cell_1_0, cell_0_1, cell_1_1 ]
    end
    
    it "returns neighbours of the top-right corner" do
      grid.neighbours(2, 0).should =~ [ cell_1_0, cell_2_1, cell_1_1 ]
    end
    
    it "returns neighbours of the bottom-left corner" do
      grid.neighbours(0, 1).should =~ [ cell_0_0, cell_1_1, cell_1_0 ]
    end
    
    it "returns neighbours of the bottom-right corner" do
      grid.neighbours(2, 1).should =~ [ cell_1_1, cell_2_0, cell_1_0 ]
    end
  end
  
  describe "#evolve_from" do
    let(:reference_grid) { mock("Reference Grid") }
    it "tell each cell to evolve" do
      reference_grid.should_receive(:neighbours).with(0, 0).and_return(:neighbours_of_0_0)
      reference_grid.should_receive(:neighbours).with(1, 0).and_return(:neighbours_of_1_0)
      reference_grid.should_receive(:neighbours).with(2, 0).and_return(:neighbours_of_2_0)
      reference_grid.should_receive(:neighbours).with(0, 1).and_return(:neighbours_of_0_1)
      reference_grid.should_receive(:neighbours).with(1, 1).and_return(:neighbours_of_1_1)
      reference_grid.should_receive(:neighbours).with(2, 1).and_return(:neighbours_of_2_1)
      cell_0_0.should_receive(:evolve).with(:neighbours_of_0_0)
      cell_1_0.should_receive(:evolve).with(:neighbours_of_1_0)
      cell_2_0.should_receive(:evolve).with(:neighbours_of_2_0)
      cell_0_1.should_receive(:evolve).with(:neighbours_of_0_1)
      cell_1_1.should_receive(:evolve).with(:neighbours_of_1_1)
      cell_2_1.should_receive(:evolve).with(:neighbours_of_2_1)
      grid.evolve_from(reference_grid)
    end
  end
  
  describe "#representation" do
    it "returns an array describing the grid" do
      cell_2_0.stub(alive?: true)
      cell_1_1.stub(alive?: true)
      grid.representation.should eq [
        [false, false, true],
        [false, true, false]
      ]
    end
  end
  
  describe "#update_from_representation" do
    it "sets cells to alive where the representation has a true value" do
      cell_2_0.should_receive(:become_alive)
      cell_1_1.should_receive(:become_alive)
      grid.update_from_representation(
        [
          [false, false, true],
          [false, true, false]
        ]
      )
    end
  end
end