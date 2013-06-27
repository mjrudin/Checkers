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
    player = h1
    other_player = h2

    puts "\n    Welcome to Checkers!"
    until game_over? do
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

game = Game.new
game.play