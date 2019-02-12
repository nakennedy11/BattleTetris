defmodule Tetrismp.Game do

# GameState, bitches:
  # gameboard: function that returns a list of 200 0's (a 1d array)
  # current piece (some tuple or object)
  # next piece (some tuple or object)
  # lines destroyed (integer)
  
  def new do
    %{
      board: init_board
      current_piece: random_piece
      next_piece: %{}
      lines_destroyed: 0
      }
  end

  def client_view(game) do
    
  end

  # initialize the board with a list of 0's
  def init_board do
    List.duplicate(0, 200) # make a list of 200 0's to represent all the unfilled squares
  end

  # generate one of 7 random possible pieces given a random number 
  # PROPERTIES OF PIECES
  ## Anchor point (all points based off this reference (of x and y))
  ## They all the same starting anchor point
  ## Each piece has an orientation (LGBT (left, gright, bottom, top)) DEFAULT:: top
  ## Each piece has a type
  
  def random_piece do
    rand = :rand.uniform(7)
    i = 20;
    j = 5;

    %{
      i: i,
      j: j,
      type: rand,
      orientation: 1
    }
           
      # Piece 1 THE GOLDEN BOY, ALL STRAIGHT 4 IN A ROW  

      # Piece 2 lil t guy

      # Piece 3 block boy jb

      # Piece 4 reverse z man

      # Piece 5 a little z boy

      # Piece 6 backwards L (aka a W)

      # Piece 7 L (upright facing)

  end

end
