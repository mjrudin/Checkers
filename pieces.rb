
require 'colored'

class Piece

  attr_accessor :color, :location, :type

  def initialize(color, location)
    @color = color
    @location = location
    @type = nil
	end

  def piece_symbol
    if @type == :king
      symbol = " ◉ ".white_on_blue if @color == :white
      symbol = " ◉ ".black_on_blue if @color == :black
    else
      symbol = " ◎ ".white_on_blue if @color == :white
      symbol = " ◎ ".black_on_blue if @color == :black
    end
    symbol
  end

  def try_to_make_king(x_value)
    if (@color == :white && x_value == 0) || (@color == :black && x_value == 7)
      @type = :king
    end
  end

end