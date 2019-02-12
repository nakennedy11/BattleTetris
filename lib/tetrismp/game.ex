defmodule Tetrismp.Game do

# GameState:
  # gameboard: function that returns a list of 200 0's (a 1d array)
  # current piece (some tuple or object)
  # next piece (some tuple or object)
  # lines destroyed (integer)
  
  def new do
    %{
      board: List.duplicate(0, 200), # make a list of 200 0's to represent all the unfilled squares
      current_piece: Map.values(random_piece),
      next_piece: Map.values(random_piece),
      lines_destroyed: 0
      }
  end

  # generate one of 7 random possible pieces given a random number 
  # PROPERTIES OF PIECES
  ## Anchor point (all points based off this reference (of x and y))
  ## They all the same starting anchor point
  ## Each piece has an orientation (LGBT (left, gright, bottom, top)) DEFAULT:: top
  ## Each piece has a type
  
  def random_piece do
    # Piece 1 THE GOLDEN BOY, ALL STRAIGHT 4 IN A ROW  
    # Piece 2 lil t guy
    # Piece 3 block boy jb
    # Piece 4 reverse z man
    # Piece 5 a little z boy
    # Piece 6 backwards L (aka a W)
    # Piece 7 L (upright facing)


    %{
      i: 0, #this has to be 0 because of the way the gameboard is arranged >;(
      j: 5,

      orientation: 1, # phx was swapping orientation and piece for some reason, so I swapped them in the code to keep it consistent
      piece: :rand.uniform(7), #this will be the type of piece

    }
           
  end

  # returns the updated game state with the piece on the board
  def render_piece(game) do
    piece = game.current_piece
    {_, piece_type} = Enum.fetch(piece, 3)
    {_, i} = Enum.fetch(piece, 0)
    {_, j} = Enum.fetch(piece, 0)
    anchor = i * 20 + j # this is the corresponding index of the anchor point of the piece
    board = List.replace_at(game.board, anchor, 1) # updating the value of game board w/anchor point

    # now we need to change the rest of game board based on the type of piece 
    cond do
      piece_type == 1 ->
        game
      piece_type == 2 ->
        game
      piece_type == 3 ->
        game
      piece_type == 4 ->
        game
      piece_type == 5 ->
        game
      piece_type == 6 ->
        game
      piece_type == 7 ->
        game
    end      
  end

end
