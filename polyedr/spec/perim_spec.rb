require 'rspec'
require_relative '../shadow/polyedr'
require_relative '../common/polyedr'
require_relative '../common/tk_drawer'
require_relative 'support/matchers/to_be_close.rb'

# EPS = 1E-12

describe Facet do
  context"Facet stuff" do
    fac = Facet.new([R3.new(0,0,0),R3.new(0,1,0),R3.new(1,0,0),R3.new(1,1,0)])
    fac.edges = [Edge.new(R3.new(0,0,0),R3.new(0,1,0)),Edge.new(R3.new(0,1,0),R3.new(1,1,0)),
    Edge.new(R3.new(1,1,0),R3.new(1,0,0)),Edge.new(R3.new(1,0,0),R3.new(0,0,0))]

    it "perimeter" do
      expect(fac.perimeter).to be_within(EPS).of(4)
    end
  end
end
describe R3 do
  context "R3Points distance between projections onto XY plane" do
    it "segment parallel to OX" do
      expect(R3.new(0,0,0).dist_pr(R3.new(1,0,0))).to be_within(EPS).of(1.0)
    end

    it "inclined segment" do
      expect(R3.new(0,0,0).dist_pr(R3.new(1,1,0))).to be_within(EPS).of(Math.sqrt(2))
    end

    it "segment parallel to OY" do
      expect(R3.new(7,8,3).dist_pr(R3.new(7,4,3))).to be_within(EPS).of(4)
    end
  end
end

describe Polyedr do

  context "Visibility" do
    let(:fig){Polyedr.new("../data/mytest.geom")}

    it "perimeter" do
      fig.draw
      expect(fig.sum).to be_within(EPS).of(800)
    end
    it "At least one facet is partially visible" do
      fig.draw
      expect(fig.facets.any?{|f| f.part_vis?}).to be true
    end

    it "Not all facets are partially visible" do
      fig.draw
      expect(fig.facets.all?{|f| f.part_vis?}).to be false
    end

    it "All edges of a non-part_vis facet are either complitely visible or complitely invisible" do
      fig.draw
      fig.facets[0].part_vis? ? temp = fig.facets[1] : temp = fig.facets[0]
      expect(temp.edges.all?{|e| e.compl_visible?||e.invisible?}).to be true
    end
  end

  context "Center inside a square" do
# ____________________
# |  _______________  |
# | |               | |
# | |               | |
# | |               | |
# | |               | |
# | |       1       | |
# | |    (-1.75,-3) | |_____
# | |     3.5x6     | |___  |
# | |               | |   | |
# | |_______________| |   | |
# |___________________|   | |
#            | |     0----| |----->x
#            | |   (0,0)  | |
#            | |    1x1   | |
#            | |__________| |
#            |______________|

    let(:fig){Polyedr.new("../data/mytest0.geom")}
    it "Facet center projection is inside a unit square" do
      fig.draw
      expect(fig.facets[0].outside_sqr?(fig.alpha,fig.beta,fig.gamma,fig.c)).to be false
      expect(fig.facets[1].outside_sqr?(fig.alpha,fig.beta,fig.gamma,fig.c)).to be true
    end

    it "In this case the sum is zero even though there is a partially visible facet" do
      fig.draw
      expect(fig.sum).to be_within(EPS).of(0)
    end
  end

   context "More examples" do
     let(:fig){Polyedr.new("../data/mytest1.geom")}
     it "Sum of perimeters" do
       fig.draw
       expect(fig.sum).to be_within(EPS).of(800+Math.sqrt(8*8+4)*40+2*40+8*40)
     end
   end
end
