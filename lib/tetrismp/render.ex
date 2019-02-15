defmodule Tetrismp.Render  do

  #calculate the index given i & j
  def idx(i, j) do
    i * 10 + j
  end

  # return a list of board indices for where the piece is 
  def long_piece(i, j, orientation) do
    idx0 = idx(i,j)

    cond do
      orientation == 0 or orientation == 2  ->
        idx1 = idx(i+1, j)
        idx2 = idx(i+2, j)
        idx3 = idx(i+3, j)
        [idx0, idx1, idx2, idx3]
      orientation == 1 or orientation == 3 ->
        idx1 = idx(i, j + 1)
        idx2 = idx(i, j + 2)
        idx3 = idx(i, j + 3)
        [idx0, idx1, idx2, idx3]
    end

  end


  def t_piece(i, j, orientation) do
    idx0 = idx(i, j)

    cond do
      orientation == 0   ->
        idx1 = idx(i+1, j)
        idx2 = idx(i, j - 1)
        idx3 = idx(i, j + 1)
        [idx0, idx1, idx2, idx3]
      orientation == 1 ->
        idx1 = idx(i, j - 1)
        idx2 = idx(i - 1, j - 1)
        idx3 = idx(i + 1, j - 1)
        [idx0, idx1, idx2, idx3]
      orientation == 2 ->
        idx1 = idx(i - 1, j)
        idx2 = idx(i - 1, j - 1)
        idx3 = idx(i - 1, j + 1)
        [idx0, idx1, idx2, idx3]
      orientation == 3 ->
        idx1 = idx(i, j + 1)
        idx2 = idx(i - 1, j + 1)
        idx3 = idx(i + 1, j + 1)
        [idx0, idx1, idx2, idx3]
    end
  end

  def square_piece(i, j, _orientation)  do
    idx0 = idx(i, j)
    idx1 = idx(i + 1, j)
    idx2 = idx(i, j + 1)
    idx3 = idx(i + 1, j + 1)    
    [idx0, idx1, idx2, idx3]
    
  end


  def rev_z_piece(i, j, orientation) do
    idx0 = idx(i, j)

    cond do
      orientation == 0 or orientation == 2 ->
        idx1 = idx(i, j - 1)
        idx2 = idx(i + 1, j - 1)
        idx3 = idx(i + 1, j - 2)
        [idx0, idx1, idx2, idx3]
      orientation == 1 or orientation == 3 ->
        idx1 = idx(i - 1, j)
        idx2 = idx(i - 1, j - 1)
        idx3 = idx(i - 2, j - 1)
        [idx0, idx1, idx2, idx3]
    end
  end


  def z_piece(i, j, orientation) do
    idx0 = idx(i, j)

    cond do
      orientation == 0 or orientation == 2 ->
        idx1 = idx(i, j + 1)
        idx2 = idx(i + 1, j + 1)
        idx3 = idx(i + 1, j + 2)
        [idx0, idx1, idx2, idx3]
      orientation == 1 or orientation == 3 ->
        idx1 = idx(i + 1, j)
        idx2 = idx(i + 1, j - 1)
        idx3 = idx(i + 2, j - 1)
        [idx0, idx1, idx2, idx3]
    end
  end


  def rev_l_piece(i, j, orientation) do
    idx0 = idx(i, j)

    cond do
      orientation == 0   ->
        idx1 = idx(i + 1, j)
        idx2 = idx(i + 2, j)
        idx3 = idx(i + 2, j - 1)
        [idx0, idx1, idx2, idx3]
      orientation == 1 ->
        idx1 = idx(i, j - 1)
        idx2 = idx(i, j - 2)
        idx3 = idx(i - 1, j - 2)
        [idx0, idx1, idx2, idx3]
      orientation == 2 ->
        idx1 = idx(i - 1, j)
        idx2 = idx(i - 2, j)
        idx3 = idx(i - 2, j + 1)
        [idx0, idx1, idx2, idx3]
      orientation == 3 ->
        idx1 = idx(i, j + 1)
        idx2 = idx(i, j + 2)
        idx3 = idx(i + 1, j + 2)
        [idx0, idx1, idx2, idx3]
    end
  end


  def l_piece(i, j, orientation) do
    idx0 = idx(i, j)

    cond do
      orientation == 0   ->
        idx1 = idx(i + 1, j)
        idx2 = idx(i + 2, j)
        idx3 = idx(i + 2, j + 1)
        [idx0, idx1, idx2, idx3]
      orientation == 1 ->
        idx1 = idx(i, j - 1)
        idx2 = idx(i, j - 2)
        idx3 = idx(i + 1, j - 2)
        [idx0, idx1, idx2, idx3]
      orientation == 2 ->
        idx1 = idx(i - 1, j)
        idx2 = idx(i - 2, j)
        idx3 = idx(i - 2, j - 1)
        [idx0, idx1, idx2, idx3]
      orientation == 3 ->
        idx1 = idx(i, j + 1)
        idx2 = idx(i, j + 2)
        idx3 = idx(i - 1, j + 2)
        [idx0, idx1, idx2, idx3]
    end
  end
end
