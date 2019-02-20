defmodule TetrismpWeb.GamesChannel do
  use TetrismpWeb, :channel

  alias Tetrismp.Game
  alias Tetrismp.BackupAgent
  alias Tetrismp.GameServer


  def join("games"<>name, payload, socket) do
    if authorized?(payload) do
      game = BackupAgent.get(name)
      if !game do
        IO.puts("HERE")
        new_game = Game.new() 

      BackupAgent.put(name, new_game)
       GameServer.start(name)
      socket = socket
      |> assign(:game, new_game)
      |> assign(:name, name)

             {:ok, %{"joined" => name, "game" => new_game}, socket}

   else
      
       BackupAgent.put(name, game)
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"joined" => name, "game" => game}, socket}
    end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("render_piece", %{}, socket) do
    game = GameServer.render_piece(socket.assigns[:user])
    push_update! game, socket
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

  def handle_in("update_board", %{"board" => board}, socket) do
    game = Game.update_board(socket.assigns[:game], board) 
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
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
