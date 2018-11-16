class Board
  attr_writer :cells
  attr_accessor :generation
  attr_reader :min_x, :max_x, :min_y, :max_y

  def initialize(generation_zero)
    @generation = 0
    @cells = Hash.new(nil)
    @generation_zero = generation_zero

    generation_zero.each_with_index do |xs, x|
      xs.each_with_index do |ys, y|
        puts "x=#{x}, y=#{y}, status=#{ys ? :alive : :dead}"
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

  def next(gen, display_x_min, display_x_max, display_y_min, display_y_max)
    # @generation += 1 # I don't think the board needs to keep track of generations. That can be done externally.
    # return the board as an array of 1 and nil, same as given
    xs = Array.new(display_x_max - display_x_min)
    return_grid = Array.new((display_y_max - display_y_min), xs)

    puts "return_grid.size=#{return_grid.size}; expected to be `10`"
    puts "return_grid[0].size=#{return_grid[0].size}; expected to be `10`"

    puts

    (display_x_min...display_x_max).to_a.each do |x|
      (display_y_min...display_y_max).to_a.each do |y|
        #return_grid[x][y] = @cells[ [x, y] ]&.alive? ? 1 : nil

        if @cells[ [x, y] ]&.alive?
          puts "x=#{x}, y=#{y}, @cells[ [#{x}, #{y}] ]=#{@cells[ [x, y] ]}=alive"
          return_grid[x][y] = 1
        else
          puts "x=#{x}, y=#{y}, @cells[ [#{x}, #{y}] ]=#{@cells[ [x, y] ]}=dead"
          # puts "return_grid=#{return_grid}"
          # puts "return_grid[#{x}]=#{return_grid[x]}"
          # puts "return_grid[#{x}][#{y}]=#{return_grid[x][y]}"
          return_grid[x][y] = 0
        end
      end
    end

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

  def alive?

  end

  def position
    [@x, @y]

  end
end

class Display
  attr_accessor :x_min, :x_max, :y_min, :y_max

  def initialize(x_min, x_max, y_min, y_max)
    @x_min = x_min
    @x_max = x_max
    @y_min = y_min
    @y_max = y_max

  end

  def register
    puts 'Not Implemented: #registered'
  end
end

def main
  display = Display.new(x_min: 0, x_max: 10, y_min: 0, y_max: 10)
  board = Board.new(generation_zero: [ [ 1, nil ], [ 1, nil ] ] )

  generation = 0
  loop do
    generation += 1
    display board.next(generation,
      display_x_min: display.x_min,
      display_x_max: display.x_max,
      display_y_min: display.y_min,
      display_y_max: display.y_max,
    )
  end
end
