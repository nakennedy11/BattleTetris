defmodule TetrismpWeb.GamesChannel do
  use TetrismpWeb, :channel

  alias Tetrismp.Game
  alias Tetrismp.BackupAgent

  def join("games"<>name, payload, socket) do
    if authorized?(payload) do
      game = BackupAgent.get(name) || Game.new() # todo, assign a back up agent once created
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"joined" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("render_piece", %{}, socket) do
    game = Game.render_piece(socket.assigns[:game], 1) # want to render the piece by changing the values of the board
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  
  end

  def handle_in("render_next_piece", %{}, socket) do
    game = Game.render_next_piece(socket.assigns[:game]) # want to render the piece by changing the values of the board
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{"game" => game}}, socket}
    
  end

  def handle_in("piece_fall", %{}, socket) do
    game = Game.piece_fall(socket.assigns[:game]) # increment the anchor y val 
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("rotate", %{}, socket) do
    game = Game.change_orientation(socket.assigns[:game]) # increment the anchor y val 
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    game = Game.move(socket.assigns[:game], direction) # move the game piece in the corresponding direcion 
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
