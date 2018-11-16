require './life.rb'

RSpec.describe "Conway's Game of Life" do
  describe "test 1" do
    it "is true" do
      expect(true)
    end
  end

  describe "can create a display" do
    let(:display) { Display.new(x_min: 0, x_max: 10, y_min: 0, y_max: 10) }

    it "is valid" do
      expect(display.x_min).to eql(0)
      expect(display.x_max).to eql(10)
      expect(display.y_min).to eql(0)
      expect(display.y_max).to eql(10)
    end
  end

  describe "can create a board" do
    let(:board) { Board.new(
      generation_zero: [
        [nil,1,nil],
        [nil,1,nil],
        [nil,1,nil],
      ]) }

    it "#show works" do
      expect(board.show(
        gen: 0,
        display_x_min: 0,
        display_x_max: 2,
        display_y_min: 0,
        display_y_max: 2,
      )).to eql([
        [nil,1,nil],
        [nil,1,nil],
        [nil,1,nil],
        ])


    end
  end

end
