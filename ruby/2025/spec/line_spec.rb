RSpec.describe Line do
  describe ".intersects?" do
    context "when the two lines intersect" do
      let(:l1) { Line.new(Vec2.new(10, 10), Vec2.new(10, 20)) }
      let(:l2) { Line.new(Vec2.new(5, 15), Vec2.new(15, 15)) }

      it "returns false" do
        expect(l1.intersects?(l2)).to eq(true)
        expect(l2.intersects?(l1)).to eq(true)
      end
    end

    context "when the two lines are collinear" do
      let(:l1) { Line.new(Vec2.new(10, 10), Vec2.new(10, 20)) }
      let(:l2) { Line.new(Vec2.new(10, 5), Vec2.new(10, 20)) }

      it "returns false" do
        expect(l1.intersects?(l2)).to eq(false)
        expect(l2.intersects?(l1)).to eq(false)
      end
    end

    context "when the two lines have the same points" do
      let(:l1) { Line.new(Vec2.new(10, 10), Vec2.new(20, 20)) }
      let(:l2) { Line.new(Vec2.new(10, 10), Vec2.new(20, 20)) }

      it "returns false" do
        expect(l1.intersects?(l2)).to eq(false)
        expect(l2.intersects?(l1)).to eq(false)
      end
    end

    context "when the two lines share a point" do
      let(:l1) { Line.new(Vec2.new(10, 10), Vec2.new(20, 20)) }
      let(:l2) { Line.new(Vec2.new(1, 1), Vec2.new(10, 10)) }

      it "returns false" do
        expect(l1.intersects?(l2)).to eq(false)
        expect(l2.intersects?(l1)).to eq(false)
      end
    end
  end
end
