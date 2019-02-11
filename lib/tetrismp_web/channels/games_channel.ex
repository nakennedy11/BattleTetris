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
      {:ok, %{"joined" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
