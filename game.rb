require './user'
require './board'
require 'colored'

class Game
  
  def initialize
    @board_object = Board.new
  end

  def play
    h1 = User.new(:white, @board_object)
    h2 = User.new(:black, @board_object)
    
    #REV: It might be good to store the players in a players array.
    player = h1
    other_player = h2
    
    puts "\n    Welcome to Checkers!"
    until game_over? do
      #REV: A simpler way that you could swap the players every turn is to store
      #the players in an array, call shift on that array to get the first player, and
      #then push the player onto the back of the array when you're finished.
      player.move
      player = player == h1 ? h2 : h1
      other_player = other_player == h2 ? h1 : h2
    end
    puts "\n***   #{other_player.color.capitalize} wins!   ***"
  end


  def game_over?
    if @board_object.white_count == 0 || @board_object.black_count == 0
      return true
    end 
  end

end
#REV: You can use the 'if __FILE__ == $PROGRAM_NAME' trick to create an 
#execution script here.
game = Game.new
game.play