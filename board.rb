#REV: I think this should read # -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require 'colored'
require './pieces'

class Board
  attr_accessor :board, :white_count, :black_count

	def initialize
		@board = setup_board
    @white_count = 12
    @black_count = 12
	end
  
  #REV: the attr_accessor creates this automatically
  def board
    @board
  end

#Initial board setup
  def setup_board
    @board = Array.new(8) { Array.new(8) }
    
    #REV: you don't need to set @board to equal the return value of setup_pieces
    #since setup_pieces alters the @board object itself and doesn't seem to return
    #anything.
    @board = setup_pieces
  end

  def setup_pieces
    pieces_array = [:black, :white]
    @board.each_with_index do |row, index|
      row.length.times do |space|
        if index < 3 && (index + space) % 2 == 1
          @board[index][space] = Piece.new(pieces_array[0],[index,space])
        elsif index > 4 && (index + space) % 2 == 1
          @board[index][space] = Piece.new(pieces_array[1],[index,space])
        end
      end
    end
  end


#Piece movement
  def move_piece(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    @board[x2][y2] = @board[x1][y1]
    @board[x2][y2].location = desired_location
    @board[x2][y2].try_to_make_king(x2)

    @board[x1][y1] = nil
  end

  def valid_move?(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location

    dx = (x2 - x1).abs
    dy = (y2 - y1).abs

    if dy > 1 || dx > 1
      return valid_capture?(current_location, desired_location)
    else 
      return valid_non_capture?(current_location, desired_location)
    end
  end


  def valid_capture?(current_location, desired_location)
    piece_type = @board[current_location[0]][current_location[1]].type
    x2, y2 = desired_location

    if piece_type == :king
      desired_dark_space?(x2, y2) && 
      desired_location_empty?(desired_location) && 
      can_capture?(current_location, desired_location)
      return true
    else
      desired_dark_space?(x2, y2) && 
      forward_direction?(current_location, desired_location) &&
      desired_location_empty?(desired_location) && 
      can_capture?(current_location, desired_location

      return true
    end

    return false
  end
  
  #REV: This looks very similar to valid_capture?. Maybe you could find a way to
  #combine them into one method.
  def valid_non_capture?(current_location, desired_location)
    piece_type = @board[current_location[0]][current_location[1]].type
    x2, y2 = desired_location

    if piece_type == :king
      desired_dark_space?(x2, y2) && 
      desired_location_empty?(desired_location) &&
      single_move?(current_location, desired_location)
      return true
    else
      desired_dark_space?(x2, y2) && 
      forward_direction?(current_location, desired_location) &&
      desired_location_empty?(desired_location) &&
      single_move?(current_location, desired_location)
      return true
    end

    return false
  end


#Checks done by valid_move, must be true for movement
  def desired_dark_space?(row,space)
    return true if (row + space) % 2 == 1

    raise "\n* All pieces must stay on dark spaces. *"
  end

  def forward_direction?(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    return true if @board[x1][y1].color == :white && x2 < x1
    return true if @board[x1][y1].color == :black && x2 > x1

    raise "\n* A piece can't move backwards unless the piece is a king. *"
  end

  def desired_location_empty?(desired_location)
    x2, y2 = desired_location
    return true if @board[x2][y2].nil?

    raise "\n* You may not land on a space with a piece. *"
  end

  def single_move?(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    return true if (x2 - x1).abs == 1 && (y2 - y1).abs == 1

    raise "\n* A non capturing piece can only move one space. *"
  end

  def can_capture?(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    
    #REV: This is clever. Nice job!
    capt_x = x1 + (x2 <=> x1)
    capt_y = y1 + (y2 <=> y1)

    if (x2 - x1).abs > 2 || (y2 - y1).abs > 2
      raise "\n* Capturing moves can only jump one space at a time. *"
    elsif @board[capt_x][capt_y].nil?
      raise "\n* A non capturing piece can only move one space. *"
    elsif @board[capt_x][capt_y].color == @board[x1][y1].color
      raise "\n* You may not capture your own piece. *"
    end

    #If you can capture, remove the captured piece and return true.
    capture_piece(capt_x, capt_y)
    return true
  end

  def capture_piece(capt_x, capt_y)
    if @board[capt_x][capt_y].color == :white
      
      #REV: you can use -= here.
      @white_count = @white_count - 1
    else
      @black_count = @black_count - 1
    end
    @board[capt_x][capt_y] = nil
  end



#Display methods and helpers
  def display_board
    #REV: you can use a range to create the numbers array (0..7).to_a
    bottom_numbers = [0,1,2,3,4,5,6,7]
    @board.each_with_index do |row, index|
      puts "#{index} #{formatted_row(row,index)}"
    end
    puts "   #{bottom_numbers.join("  ")}"
  end

  def formatted_row(row, index)
    row_array = []
    i = index
    row.each_with_index do |space, j|
      if space.nil? && black_space?(i, j)
        row_array << "   ".on_blue
      elsif space.nil?
        row_array << "   ".on_cyan
      else 
        row_array << space.piece_symbol
      end
    end
    
    row_array.join("")
  end

  def black_space?(row,space)
    #returns true for black spaces
    (row + space) % 2 == 1
  end

end
