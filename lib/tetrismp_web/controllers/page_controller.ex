defmodule TetrismpWeb.PageController do
  use TetrismpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, params) do
    user = get_session(conn, :user)
    if user do # if the user exists
      render conn, "game.html", name: params["name"], user: user
    end
  end

  def game_form(conn, params) do
    game = params["name"]
    conn
    |> put_session(:user, params["user"])
    |> redirect(to: "/game/#{game}")   
  end



end
