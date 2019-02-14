defmodule Tetrismp.Game do

# GameState:
  # gameboard: function that returns a list of 200 0's (a 1d array)
  # current piece (some tuple or object)
  # next piece (some tuple or object)
  # lines destroyed (integer)
  
  def new do
    %{
      board: List.duplicate(0, 200), # make a list of 200 0's to represent all the unfilled squares
      current_piece: Map.values(random_piece()),
      next_piece: Map.values(random_piece()),
      side_board: List.duplicate(0, 16), # 4x4 grid should be enough to render any piece, slightly overkill but annoying to do math for 3x4 or something or 2x4
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
      j: 4,
      orientation: 1, # phx was swapping orientation and piece for some reason, so I swapped them in the code to keep it consistent
      piece: :rand.uniform(7), #this will be the type of piece
    }
           
  end

  #calculate the index given i & j
  def idx(i, j) do
    i * 10 + j
  end

  # replace elements in board and update the game state
  def replace_board(i, j, game, x) do
    index = idx(i,j)
    new_list = List.replace_at(game.board, index, x) # replacing in game board
    Map.put(game, :board, new_list) # updating in game state
  end

  # returns the updated game state with the piece on the board
  def render_piece(game, x) do
    piece = game.current_piece
    {_, piece_type} = Enum.fetch(piece, 3)
    {_, i} = Enum.fetch(piece, 0)
    {_, j} = Enum.fetch(piece, 1)
    game = replace_board(i, j, game, x)
   
    # now we need to change the rest of game board based on the type of piece 
    cond do
      piece_type == 1 ->
        long_piece(game, i, j, 1, x)
      piece_type == 2 ->
        t_piece(game, i, j, 1, x)
      piece_type == 3 ->
        square_piece(game, i, j, 1, x)
      piece_type == 4 ->
        rev_z_piece(game, i, j, 1, x)
      piece_type == 5 ->
        z_piece(game, i, j, 1, x)
      piece_type == 6 ->
        rev_l_piece(game, i, j, 1, x)
      piece_type == 7 ->
        l_piece(game, i, j, 1, x)
    end      
  end

  # essentially a duplicate of the above render function, will probably abstract it
  # but it doesn't need nearly the level of complication so might just leave it a simple boy
  def render_next_piece(game) do
    piece = game.next_piece
    {_, piece_type} = Enum.fetch(piece, 3)

    # I drew out grids for each piece and just put in all the squares where they should be
    cond do
      piece_type == 1 ->
        new_list = game.side_board
        |> List.replace_at(1,  1)
        |> List.replace_at(5,  1)
        |> List.replace_at(9,  1)
        |> List.replace_at(13, 1)

        Map.put(game, :side_board, new_list)
      piece_type == 2 ->
        new_list = game.side_board
        |> List.replace_at(9,  1)
        |> List.replace_at(12, 1)
        |> List.replace_at(13, 1)
        |> List.replace_at(14, 1)

        Map.put(game, :side_board, new_list)
      piece_type == 3 ->
        new_list = game.side_board
        |> List.replace_at(8,  1)
        |> List.replace_at(9,  1)
        |> List.replace_at(12, 1)
        |> List.replace_at(13, 1)

        Map.put(game, :side_board, new_list)
      piece_type == 4 ->
        new_list = game.side_board
        |> List.replace_at(9,  1)
        |> List.replace_at(10, 1)
        |> List.replace_at(12, 1)
        |> List.replace_at(13, 1)

        Map.put(game, :side_board, new_list)
      piece_type == 5 ->
        new_list = game.side_board
        |> List.replace_at(8,  1)
        |> List.replace_at(9,  1)
        |> List.replace_at(13, 1)
        |> List.replace_at(14, 1)

        Map.put(game, :side_board, new_list)
      piece_type == 6 ->
        new_list = game.side_board
        |> List.replace_at(5,  1)
        |> List.replace_at(9,  1)
        |> List.replace_at(12, 1)
        |> List.replace_at(13, 1)

        Map.put(game, :side_board, new_list)
      piece_type == 7 ->
        new_list = game.side_board
        |> List.replace_at(4,  1)
        |> List.replace_at(8,  1)
        |> List.replace_at(12, 1)
        |> List.replace_at(13, 1)

        Map.put(game, :side_board, new_list)
    end

  end
  

  #TODO: Maybe move this to another file?

  # change values in board list for the long piece
  def long_piece(game, i, j, count, x) do
    if (count < 4) do #recursively call this function if the count is less than 4, we are changing values of game board 
        i = i + 1
        new_game = replace_board(i, j, game, x)
        long_piece(new_game, i, j, count + 1, x)
     else
       game #long boy is done, return game state
    end
  end

  # change values in board list for the t piece
  def t_piece(game, i, j, count, x) do
    cond do
      count == 1 ->
        j = j + 1
        new_game = replace_board(i, j, game, x)
        t_piece(new_game, i, j, count + 1, x)
      count == 2 ->
        j = j - 2 #need to navigate back to the anchor point so index math doesn't get messed up 
        new_game = replace_board(i, j, game, x)
        t_piece(new_game, i, j, count + 1, x)
       count == 3 ->
        i = i + 1
        j = j + 1
        replace_board(i, j, game, x) # we can return here because there's nothing left to add
    end
  end

  # change the values in board list for the square piece
  def square_piece(game, i, j, count, x) do
    cond do
      count == 1 ->
        i = i + 1
        new_game = replace_board(i, j, game, x)
        square_piece(new_game, i, j, count + 1, x)
      count == 2 ->
        i = i - 1
        j = j + 1
        new_game = replace_board(i, j, game, x)
        square_piece(new_game, i, j, count + 1, x)
      count == 3 ->
        i = i + 1
        replace_board(i, j, game, x)
    end
  end

  # change the values in board list for the reverse z piece
  def rev_z_piece(game, i, j, count, x)do
    cond do 
      count == 1 ->
        j = j - 1
        new_game = replace_board(i, j, game, x)
        rev_z_piece(new_game, i, j, count + 1, x)
      count == 2 ->
        j = j + 1
        i = i + 1
        new_game = replace_board(i, j, game, x)
        rev_z_piece(new_game, i, j, count + 1, x)
      count == 3 ->
        j = j + 1
        replace_board(i, j, game, x)
    end
  end

  # change the values in board list for the z piece
  def z_piece(game, i, j, count, x) do
    cond do
      count == 1 ->
        j = j + 1
        new_game = replace_board(i, j, game, x)
        z_piece(new_game, i, j, count + 1, x)
      count == 2 ->
        j = j - 1
        i = i + 1
        new_game = replace_board(i, j, game, x)
        z_piece(new_game, i, j, count + 1, x)
      count == 3 ->
        j = j - 1
        replace_board(i, j, game, x)
    end   
  end

  # change the values in board list for the reverse l piece
  def rev_l_piece(game, i, j, count, x) do
    cond do
      count == 1 ->
        i = i + 1
        new_game = replace_board(i, j, game, x)
        rev_l_piece(new_game, i, j, count + 1, x)
      count == 2 ->
        i = i + 1
        new_game = replace_board(i, j, game, x)
        rev_l_piece(new_game, i, j, count + 1, x)
      count == 3 ->
        j = j - 1
        replace_board(i, j, game, x)
    end
  end

  # change the values in board list for the l piece
  def l_piece(game, i, j, count, x) do
    cond do
      count == 1 ->
        i = i + 1
        new_game = replace_board(i, j, game, x)
        l_piece(new_game, i, j, count + 1, x)
      count == 2 ->
        i = i + 1
        new_game = replace_board(i, j, game, x)
        l_piece(new_game, i, j, count + 1, x)
      count == 3 ->
        j = j + 1
        replace_board(i, j, game, x)
    end
  end

  # falling piece function. Updates the anchor point to be one index lower
  def piece_fall(game) do
    piece = game.current_piece
    next_i = Enum.at(piece, 0) + 1 # increment i (y) value of the anchor
    temp_piece = List.replace_at(piece, 0, next_i) # replace the value in the list

    game
    |> render_piece(0) # need to unrender the old piece placement
    |> Map.put(:current_piece, temp_piece) # return the game with the new piece placement

  end

end
