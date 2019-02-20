defmodule Tetrismp.GameSup do
  use DynamicSupervisor
   
  def start_link(arg) do
    IO.puts("Start link")
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    {:ok, _} = Registry.start_link(keys: :unique, name: Tetrismp.GameReg)
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(spec) do
    IO.puts("####started child")
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
