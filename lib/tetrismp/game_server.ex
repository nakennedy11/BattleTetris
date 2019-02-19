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
    Tetrusmp.GameSup.start_child(spec)
  end

  def start_link(name) do
    game = Tetrismp.BackupAgent.get(name) || Tetris.game.new()
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  def init(game) do
    {:ok, game}
  end

  # where we're gonna add and delete lines!
  def handle_call() do

  end
  
  







end
