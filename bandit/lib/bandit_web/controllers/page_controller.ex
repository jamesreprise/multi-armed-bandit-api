defmodule BanditWeb.PageController do
  use BanditWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
