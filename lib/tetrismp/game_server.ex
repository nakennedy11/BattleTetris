defmodule Tetrismp.GameServer do
  use GenServer
  alias Tetrismp.BackupAgent
  alias Tetrismp.Game

  def reg(name) do
    {:via, Registry, {Tetrismp.GameReg, name}}
  end

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker,
    }
    Tetrismp.GameSup.start_child(spec)
  end

  def start_link(name) do
    game = BackupAgent.get(name) || Tetrismp.Game.new()
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  def init(game) do
    {:ok, game}
  end

#######################################################

  def render_piece(name) do
    GenServer.call(reg(name), {:render_piece, name})
  end

  def render_next_piece(name) do
    GenServer.call(reg(name), {:render_next_piece, name})
  end

  def piece_fall(name) do
    GenServer.call(reg(name), {:piece_fall, name})
  end

  def change_orientation(name) do
    GenServer.call(reg(name), {:change_orientation, name})
  end

  def move(name, direction) do
    GenServer.call(reg(name), {:move, name, direction})
  end

  def update_board(name, board) do
    GenServer.call(reg(name), {:update, name, board})
  end
  
#######################################################

  # handle call for render piece
  def handle_call({:render_piece, name}, _from, game) do
    game = Game.render_piece(game, 1)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  # handle call for render next piece
  def handle_call({:render_next_piece, name}, _from, game) do
    game = Game.render_next_piece(game)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  # handle call for piece fall
  def handle_call({:piece_fall, name}, _from, game) do
    game = Game.piece_fall(game)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  # handle call for change orientation
  def handle_call({:change_orientation, name}, _from, game) do
    game = Game.change_orientation(game)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  # handle call for move
  def handle_call({:move, name, direction}, _from, game) do
    game = Game.move(game, direction)
    BackupAgent.put(name, game)
    {:reply, game, game}
  end

  # handle call for update board
  def handle_call({:update, name, board}, _from, game) do
    game = Game.update_board(game, board)
    BackupAgent.put(name, game)
    {:reply, game, game}
 
  end
  
  







end
