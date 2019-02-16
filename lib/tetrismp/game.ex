defmodule Tetrismp.Game do

import Tetrismp.Render

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
      orientation: 0, # phx was swapping orientation and piece for some reason, so I swapped them in the code to keep it consistent
      piece: :rand.uniform(7), #this will be the type of piece
    }
           
  end

  #calculate the index given i & j
  def idx(i, j) do
    i * 10 + j
  end

  # replace elements in board and update the game state
  def replace_board(game, index, x) do
    new_list = List.replace_at(game.board, index, x) # replacing in game board
    Map.put(game, :board, new_list) # updating in game state
  end

  # returns the updated game state with the piece on the board
  def render_piece(game, x) do
    piece = game.current_piece
    piece_type = Enum.at(piece, 3)
    i = Enum.at(piece, 0)
    j = Enum.at(piece, 1)
    orientation = Enum.at(piece, 2)
   
    cond do
      piece_type == 1 ->
        idx_list  = long_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
      piece_type == 2 ->
        idx_list  = t_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
      piece_type == 3 ->
        idx_list  = square_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
      piece_type == 4 ->
        idx_list  = rev_z_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
      piece_type == 5 ->
        idx_list  = z_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
      piece_type == 6 ->
        idx_list  = rev_l_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
      piece_type == 7 ->
        idx_list  = l_piece(i, j, orientation)
        plot_piece(game, idx_list, x)
    end
  end

  def plot_piece(game, idx_list, x) do
    idx0 = Enum.at(idx_list, 0)
    idx1 = Enum.at(idx_list, 1)
    idx2 = Enum.at(idx_list, 2)
    idx3 = Enum.at(idx_list, 3)

    game
    |> replace_board(idx0, x)
    |> replace_board(idx1, x)
    |> replace_board(idx2, x)
    |> replace_board(idx3, x)
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
  
 
  # falling piece function. Updates the anchor point to be one index lower
  def piece_fall(game) do
    if collision?(game) do
      # collides if it falls, so update our pieces instead
      new_current_piece = game.next_piece # make the next piece the current piece
      new_next_piece = Map.values(random_piece()) # get a new random piece to be the next piece
      game
      |> Map.put(:current_piece, new_current_piece)
      |> Map.put(:next_piece, new_next_piece)

    else
      piece = game.current_piece
      next_i = Enum.at(piece, 0) + 1 # increment i (y) value of the anchor
      temp_piece = List.replace_at(piece, 0, next_i) # replace the value in the list

      game
      |> render_piece(0) # need to unrender the old piece placement
      |> Map.put(:current_piece, temp_piece) # return the game with the new piece placement
      |> render_piece(1)
    end
  end

  def change_orientation(game) do
    piece = game.current_piece
    
    piece_orientation = Enum.at(piece, 2)
    new_or = rem(piece_orientation + 1, 4)

    new_piece = List.replace_at(piece, 2, new_or)

    IO.puts(new_or)
    
    game
    |> render_piece(0)
    |> Map.put(:current_piece, new_piece) 
    
  end
  
  def move(game, direction) do
    piece = game.current_piece
    cond do
      direction == "left" ->
        next_j = Enum.at(piece, 1) - 1 
        temp_piece = List.replace_at(piece, 1, next_j)

        game
        |> render_piece(0)
        |> Map.put(:current_piece, temp_piece)
        |> render_piece(1)

      direction == "right" ->
        next_j = Enum.at(piece, 1) + 1 
        temp_piece = List.replace_at(piece, 1, next_j)

        game
        |> render_piece(0)
        |> Map.put(:current_piece, temp_piece)
        |> render_piece(1)
    end
  end

  def collision?(game) do
    board = game.board

    piece = game.current_piece
    piece_type = Enum.at(piece, 3)
    i = Enum.at(piece, 0)
    j = Enum.at(piece, 1)
    orientation = Enum.at(piece, 2)

    # cond to get the list of indices that this piece currently takes up
    cond do
      piece_type == 1 ->
        idx_list  = long_piece(i, j, orientation)
        check_collision(game, idx_list)
      piece_type == 2 ->
        idx_list  = t_piece(i, j, orientation)
        check_collision(game, idx_list)
      piece_type == 3 ->
        idx_list  = square_piece(i, j, orientation)
        check_collision(game, idx_list)
      piece_type == 4 ->
        idx_list  = rev_z_piece(i, j, orientation)
        check_collision(game, idx_list)
      piece_type == 5 ->
        idx_list  = z_piece(i, j, orientation)
        check_collision(game, idx_list)
      piece_type == 6 ->
        idx_list  = rev_l_piece(i, j, orientation)
        check_collision(game, idx_list)
      piece_type == 7 ->
        idx_list  = l_piece(i, j, orientation)
        check_collision(game, idx_list)
    end
  end

  def check_collision(game, idx_list) do
    idx0 = Enum.at(idx_list, 0)
    idx1 = Enum.at(idx_list, 1)
    idx2 = Enum.at(idx_list, 2)
    idx3 = Enum.at(idx_list, 3)

    # check if any of those lower indices are past the end of the game board
    if idx0 + 10 > 199 || idx1 + 10 > 199 || idx2 + 10 > 199 || idx3 + 10 > 199  do
      true
    else
      # get each index that is one lower than the current squares
      board_idx0 = Enum.at(board, idx0 + 10)
      board_idx1 = Enum.at(board, idx1 + 10)
      board_idx2 = Enum.at(board, idx2 + 10)
      board_idx3 = Enum.at(board, idx3 + 10)
    
      # check if any point on the board 1 lower is already occupied, make sure it isnt part of the piece
      if Enum.at(board, board_idx0) == 1 && board_idx0 != idx1 && board_idx0 != idx2 && board_idx0 != idx3 do
        # do nothing cause collides == false already
      else
        true
      end
      
      if Enum.at(board, board_idx1) == 1 && board_idx1 != idx0 && board_idx1 != idx2 && board_idx1 != idx3 do
      # do nothing cause collides == false already
      else
        true
      end
      
      if Enum.at(board, board_idx2) == 1 && board_idx2 != idx0 && board_idx2 != idx1 && board_idx2 != idx3 do
        # do nothing cause collides == false already
      else
        true
      end
      
      if Enum.at(board, board_idx3) == 1 && board_idx3 != idx1 && board_idx3 != idx2 && board_idx3 != idx0 do
        # do nothing cause collides == false already
      else
        true
      end
      false
    end
  end
  
end



