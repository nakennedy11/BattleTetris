defmodule Tetrismp.GameServer do
  use GenServer
  alias Tetrismp.BackupAgent
  alias Tetrismp.Game

  def reg(name) do
    {:via, Registry, {Tetrismp.GameReg, name}}
  end

  def start(name, id) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name, id]},
      restart: :permanent,
      type: :worker,
    }
    Tetrismp.GameSup.start_child(spec)
  end

  def start_link(name, id) do
    game = BackupAgent.get(name, id) || Tetrismp.Game.new(id)
    IO.inspect(game)
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  def init(game) do
    {:ok, game}
  end

#######################################################

  def render_piece(name, id) do
    GenServer.call(reg(name), {:render_piece, name, id})
  end

  def render_next_piece(name, id) do
    GenServer.call(reg(name), {:render_next_piece, name, id})
  end

  def piece_fall(name, id) do
    GenServer.call(reg(name), {:piece_fall, name, id})
  end

  def change_orientation(name, id) do
    GenServer.call(reg(name), {:change_orientation, name, id})
  end

  def move(name, id, direction) do
    GenServer.call(reg(name), {:move, name, id, direction})
  end

  def update_board(name, id, board) do
    GenServer.call(reg(name), {:update, name, board, id})
  end

  def update_enemy(name, id, enemy_board, enemy_lines_destroyed) do
    GenServer.call(reg(name), {:update_enemy, name, enemy_board, enemy_lines_destroyed, id})
  end

  
#######################################################

  # handle call for render piece
  def handle_call({:render_piece, name, id}, _from, game) do

    IO.puts(id)
    game = Game.render_piece(game, 1)
    BackupAgent.put(name, id, game)
    {:reply, game, game}
  end

  # handle call for render next piece
  def handle_call({:render_next_piece, name, id}, _from, game) do

    IO.puts(id)
    game = Game.render_next_piece(game)
    BackupAgent.put(name, id, game)
    {:reply, game, game}
  end

  # handle call for piece fall
  def handle_call({:piece_fall, name, id}, _from, game) do

    IO.puts(id)
    game = Game.piece_fall(game)
    BackupAgent.put(name, id, game)
    {:reply, game, game}
  end

  # handle call for change orientation
  def handle_call({:change_orientation, name, id}, _from, game) do
    
    IO.puts(id)
    game = Game.change_orientation(game)
    BackupAgent.put(name, id, game)
    {:reply, game, game}
  end

  # handle call for move
  def handle_call({:move, name, id, direction}, _from, game) do
    IO.puts(id)
    game = Game.move(game, direction)
    BackupAgent.put(name, id, game)
    {:reply, game, game}
  end

  # handle call for update_enemy
 # def handle_call({:update_enemy, name, enemy_board, enemy_lines_destroyed, id}, _from, game) do
   # IO.puts(id)
   # game = Game.update_enemy(game, enemy_board, enemy_lines_destroyed)
  #  BackupAgent.put(name, id, game)
 #   {:reply, game, game}
#  end

  # handle call for update board
  def handle_call({:update, name, board, id}, _from, game) do
    IO.puts(id)
    game = Game.update_board(game, board)
    BackupAgent.put(name, id, game)
    {:reply, game, game}
 
  end
  
  







end
