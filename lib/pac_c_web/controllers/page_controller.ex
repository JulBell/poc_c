defmodule PacCWeb.PageController do
  use PacCWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
