defmodule Lv2048Web.PageController do
  use Lv2048Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
