
require './board'
require 'colored'

class User

  attr_reader :color

  def initialize(color, board_object)
    @color = color
    @board_object = board_object
    @board = @board_object.board
  end

#PROMPT AND GET
  def get_current
    puts "#{color.capitalize}, select a piece (in the form ROW COL)."
    input = gets.chomp.downcase.split(/\s*/)
    current_location = input.map {|el| el.to_i}
    our_piece?(current_location)
    current_location
  end

  def get_desired
    puts "#{color.capitalize}, select a location to move to (in the form ROW COL)."
    input = gets.chomp.downcase.split(/\s*/)
    desired_location = input.map {|el| el.to_i}
    move_on_board?(desired_location)
    desired_location
  end

#Execute move
  def move
    begin
      @board_object.display_board
      current_location = get_current
      desired_location = get_desired
      board_dup = @board_object.dup


      if @board_object.valid_move?(current_location, desired_location)
        @board_object.move_piece(current_location, desired_location)
      end
      available_captures?(board_dup, current_location, desired_location)
      puts "\n"
    rescue StandardError => e
      puts e
      retry
    end
  end




#if player1's move is executed, look at the piece at desired_location
#if that piece has a capturing move, prompt player1 to make the capturing move
def available_captures?(board_dup, current_location, desired_location)
  x1, y1 = current_location
  x2, y2 = desired_location

  if board_dup.can_capture?(current_location, desired_location)

    #if board_dup.can_capture([x,y],[x2,y2])
  end
  
end

# If can_capture? on the original move returned true, then:
# if its a regular piece, call can_capture with a desired +/- 2 for both x and y
# if any of those return true, then we need to prompt the same player to make another 
# move


  private

  def our_piece?(current_location)
    x,y = current_location
    if @board[x][y].nil? || @board[x][y].color != self.color
      raise "\n* Invalid Move! You must select a #{self.color.capitalize} piece. *"
    end
  end

  def move_on_board?(desired_location)
    x,y = desired_location
    if x < 0 || x > 7 || y < 0 || y > 7
      raise "\n* Invalid Move! You must move to a location on the board. *"
    end
  end

end
