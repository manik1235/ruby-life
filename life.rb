require 'pry'


class Board
  attr_accessor :cells # Should probably just be a writer, but I need it to be accessor for debugging
  attr_accessor :generation
  attr_reader :min_x, :max_x, :min_y, :max_y

  def initialize(generation_zero: [ [nil,1,nil,nil],[nil,1,nil,nil],[nil,1,nil,nil] ])
    @generation = 0
    @cells = Hash.new(nil)
    @generation_zero = generation_zero

    generation_zero.each_with_index do |xs, x|
      xs.each_with_index do |ys, y|
        Cell.new(x, y, ys ? :alive : :dead, self)
      end
    end
    # The loop above appears to correctly create a 3x3 grid.
  end

  def register(cell)
    @cells[cell.position] = cell
    @min_x = cell.x if cell.x < @min_x.to_i
    @max_x = cell.x if cell.x > @max_x.to_i
    @min_y = cell.y if cell.y < @min_y.to_i
    @max_y = cell.y if cell.y > @max_y.to_i
  end

  def show(gen: 0, display_x_min: 0, display_x_max: 2, display_y_min: 0, display_y_max: 3)
    # return the board as an array of 1 and nil, same as given
    delta_x = display_x_max - display_x_min
    delta_y = display_y_max - display_y_min
    xs = Array.new(delta_x + 1)
    return_grid = Array.new((delta_y + 1), xs)

    puts "newly init'd return_grid=#{return_grid}"
    puts "delta_x=#{delta_x}"
    puts "delta_y=#{delta_y}"
    # What does @cells[[3, 3]] equal at this point?
    return_grid.size
    (0..delta_x).to_a.each do |x|
      (0..delta_y).to_a.each do |y|
        puts "x=#{x}; expected to never be >= 3"
        if @cells[ [x + display_x_min, y + display_y_min] ]&.alive?(gen: gen)
          return_grid[y][x] = 1
        else
          return_grid[y][x] = nil
        end
      end
    end
    puts "expected return_grid dimensions: 3 across, 4 down."
    return_grid
  end
end

class Cell
  attr_accessor :x, :y
  attr_reader :board # is this the right attr? Board is assigned at init, then only read thereafter. Does attr define behavior outside the class?
  attr_reader :history

  def initialize(x, y, state, board)
    @x = x
    @y = y
    @history = [state]
    @board = board

    board.register self
  end

  def alive?(gen: )
    # Use the gen to select the correct bit of history
    if gen >= @history.size
      # Calculate the new generation

      # Count living neighbors in the generation prior to the generation passed in
      neighbors = living_neighbors(gen: (gen - 1))
      if @history[gen - 1] == :alive
        if neighbors == 2 || neighbors == 3
          # If the cell was alive in the prior generation, it stays alive with 2 or 3 neighbors, and dies otherwise
          @history[gen] = :alive
        else
          @history[gen] = :dead
        end
      else
        if neighbors == 3
          # If a cell was dead in the prior generation, it is born if it has 3 neighbors, and stays dead otherwise
          @history[gen] = :alive
        else
          @history[gen] = :dead
        end
      end
    end
    # Every history generation <= `gen` should have a state now.
    @history[gen] == :alive
  end

  def position
    [@x, @y]
  end

  private

    def living_neighbors(gen: )
      [
        [-1, -1], [-1, 0], [-1, 1],
        [0, -1], [0, 1],
        [1, -1], [1, 0], [1, 1],
      ].reduce(0) do |a, v|
        dx, dy = v
        if @board.cells[[@x + dx, @y + dy]]&.alive?(gen: gen - 1)
          a += 1
        else
          a
        end
      end
    end
end

class Display
  attr_accessor :x_min, :x_max, :y_min, :y_max

  def initialize(x_min: 0, x_max: 10, y_min: 0, y_max: 10)
    @x_min = x_min
    @x_max = x_max
    @y_min = y_min
    @y_max = y_max

  end

  def display(x, adapter: :basic)
    case adapter
    when :basic
      x.each { |y| print y.to_s + "\n" }
    else
      print x
    end
  end

  def register
    puts 'Not Implemented: #registered'
  end
end

def main
  display = Display.new
  board = Board.new    # (generation_zero: [ [ 1, nil ], [ 1, nil ] ] )

  generation = 0
  loop do
    puts "\nGeneration #{generation}"
    display.display board.show(
      gen: generation,
      display_x_min: display.x_min,
      display_x_max: display.x_max,
      display_y_min: display.y_min,
      display_y_max: display.y_max,
    ),
    adapter: :basic
    binding.pry
    sleep 1
    generation += 1
  end
end
