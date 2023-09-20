defmodule PacCWeb.ResultLive.Index do
  use PacCWeb, :live_view
  alias PacC.Users.{User, Username}
  alias PacC.Votes.Vote

  def mount(_params, %{"_csrf_token" => token}, socket) do

    if connected?(socket) do
      PacCWeb.Endpoint.subscribe("result")
    end


    {:ok,
      assign(
        socket,
        topic: "result",
        winner: get_winner()
      )
    }
  end

  def get_winner() do
    choco_votes_count = Vote.count_choco()
    pac_votes_count = Vote.count_pac()
    if choco_votes_count > pac_votes_count do
      "choco"
    else
      "pac"
    end
  end

  def handle_info(%{event: "update_result", payload: _}, socket) do
    {:noreply, assign(socket, :winner, get_winner()) }
  end

  defp fetch_user(%{assigns: %{user: user}}), do: user
  defp fetch_user(_), do: nil
end
