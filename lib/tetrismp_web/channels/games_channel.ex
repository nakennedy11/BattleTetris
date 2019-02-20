defmodule TetrismpWeb.GamesChannel do
  use TetrismpWeb, :channel

  alias Tetrismp.Game
  alias Tetrismp.BackupAgent
  alias Tetrismp.GameServer


  def join("games:"<>name, payload, socket) do
    if authorized?(payload) do
      game = BackupAgent.get(name) || Game.new()
      BackupAgent.put(name, game)
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      GameServer.start(name)
      {:ok, %{"joined" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("render_piece", %{}, socket) do
    game = GameServer.render_piece(socket.assigns[:name])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket} 
  end

  def handle_in("render_next_piece", %{}, socket) do
    game = GameServer.render_next_piece(socket.assigns[:name])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("piece_fall", %{}, socket) do
    game = GameServer.piece_fall(socket.assigns[:name])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("rotate", %{}, socket) do
    game = GameServer.change_orientation(socket.assigns[:name])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
 
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    game = GameServer.move(socket.assigns[:name], direction)
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("update_board", %{"board" => board}, socket) do
    game = GameServer.update_board(socket.assigns[:name], board)
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end
  
  defp push_update!(game, socket) do
    broadcast!(socket, "update", game)
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
