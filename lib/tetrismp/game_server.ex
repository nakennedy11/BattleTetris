defmodule Tetrismp.GameServer do
  use GenServer

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
    IO.puts("IN SERVER START_LINK")
    game = Tetrismp.BackupAgent.get(name) || Tetrismp.Game.new()
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  def init(game) do
    {:ok, game}
  end

  def render_piece(name) do
    GenServer.call(reg(name), {:render_piece, name})
  end
  
  # handle call for render piece
  def handle_call({:render_piece, name}, _from, game) do
    IO.puts("####Handling call")
    game = Tetrismp.Game.render_piece(game, 1)
    Tetrismp.BackupAgent.put(name, game)
    {:reply, game, game}
  end

  
  
  







end
