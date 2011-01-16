require 'spec_helper'

describe Cell do
  let(:cell) { Cell.new }
  
  it "is not alive when first created" do
    cell.should_not be_alive
  end
  
  describe "#become_alive" do
    it "makes the cell alive" do
      cell.become_alive
      cell.should be_alive
    end
  end
  
  # This code largely copied from the pairing session with Jimmbob
  describe "evolve" do
    def cell_set_with_number_alive(living_cells)
      [ mock("Dead Cell", alive?: false) ] + [ mock("Living Cell", alive?: true) ] * living_cells
    end
    
    context "a living cell" do
      before(:each) { cell.become_alive }
      
      context "with 0 neighbours" do
        it "dies when it evolves" do
          expect { cell.evolve(cell_set_with_number_alive(0)) }.to change { cell.alive? }.from(true).to(false)
        end
      end

      context "with 1 neighbour" do
        it "dies when it evolves" do
          expect { cell.evolve(cell_set_with_number_alive(1)) }.to change { cell.alive? }.from(true).to(false)
        end
      end

      context "with 2 neighbours" do
        it "stays alive when it evolves" do
          cell.evolve(cell_set_with_number_alive(2))
          cell.should be_alive
        end
      end

      context "with 3 neighbours" do
        it "stays alive when it evolves" do
          cell.evolve(cell_set_with_number_alive(3))
          cell.should be_alive
        end
      end

      context "with 4 neighbours" do
        it "dies when it evolves" do
          expect { cell.evolve(cell_set_with_number_alive(4)) }.to change { cell.alive? }.from(true).to(false)
        end
      end
    end
    
    context "a dead cell" do
      context "with <=2 neighbours" do
        it "stays dead" do
          cell.evolve(cell_set_with_number_alive(2))
          cell.should_not be_alive
        end
      end

      context "with 3 neighbours" do
        it "springs into life" do
          expect {
            cell.evolve(cell_set_with_number_alive(3))
          }.to change { cell.alive? }.from(false).to(true)
        end
      end
      
      context "with >=4 neighbours" do
        it "stays dead" do
          cell.evolve(cell_set_with_number_alive(4))
          cell.should_not be_alive
        end
      end
    end
  end
end