defmodule TetrismpWeb.GamesChannel do
  use TetrismpWeb, :channel

  alias Tetrismp.Game
  alias Tetrismp.BackupAgent
  alias Tetrismp.GameServer

  intercept ["update"]

  def join("games:"<>name,  payload, socket) do

    if authorized?(payload) do
      IO.puts("before join")
      game = BackupAgent.get(name, payload) || Game.new(payload)
             
      IO.puts("after get")
      BackupAgent.put(name, payload, game)
      IO.inspect(BackupAgent)
      IO.puts("after put")
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      |> assign(:user, payload)
      GameServer.start(name, payload)
      {:ok, %{"joined" => name, "game" => game}, socket}


    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("render_piece", %{}, socket) do
    game = GameServer.render_piece(socket.assigns[:name], socket.assigns[:user])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket} 
  end

  def handle_in("render_next_piece", %{}, socket) do
    game = GameServer.render_next_piece(socket.assigns[:name], socket.assigns[:user])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("piece_fall", %{}, socket) do
    game = GameServer.piece_fall(socket.assigns[:name], socket.assigns[:user])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("rotate", %{}, socket) do
    game = GameServer.change_orientation(socket.assigns[:name], socket.assigns[:user])
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
 
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    game = GameServer.move(socket.assigns[:name], socket.assigns[:user], direction)
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("update_board", %{"board" => board}, socket) do
    game = GameServer.update_board(socket.assigns[:name], socket.assigns[:user], board)
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("update_game", %{ "game" => game }, socket) do
    IO.puts(Map.get(game, :id))
    if Map.get(game, :id) do
      BackupAgent.put(socket.assigns[:name], Map.get(game, :id), game)
      {:reply, {:ok, %{"game" => game}}, socket}
    end
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("update_enemy", %{"enemy_board" => enemy_board, "enemy_lines_destroyed" => enemy_lines_destroyed}, socket) do
    game = GameServer.update_enemy(socket.assigns[:name], socket.assigns[:user], enemy_board, enemy_lines_destroyed)
    push_update! game, socket
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_out("update", game_data, socket) do
    IO.inspect("Broadcasting update to #{socket.assigns[:user]}")
    IO.inspect(game_data)
    push socket, "update", %{ "game" => game_data }
    {:noreply, socket}
  end


  defp push_update!(game, socket) do
    broadcast!(socket, "update", game)
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
