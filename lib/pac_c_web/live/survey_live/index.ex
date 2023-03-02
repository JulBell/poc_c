defmodule PacCWeb.SurveyLive.Index do
  use PacCWeb, :live_view
  alias PacC.Users.{User, Username}
  alias PacC.Votes.Vote

  def mount(_params, %{"_csrf_token" => token}, socket) do

    if connected?(socket) do
      PacCWeb.Endpoint.subscribe("survey")
    end

    user = User.find_or_create_user(token)
    choco_votes_count = Vote.count_choco()
    pac_votes_count = Vote.count_pac()
    {:ok,
      assign(
        socket,
        topic: "survey",
        user: User.to_map(user),
        pac_votes_count: pac_votes_count,
        choco_votes_count: choco_votes_count,
        votes: Vote.recent_votes()
      )
    }
  end

  def handle_event("vote", %{"user" => value}, socket) do
    current_user = fetch_user(socket)
    if current_user do
      case Vote.create_vote(%{"value" => value, "user_id" => current_user.id}) do
        {:ok, %Vote{}} ->
          PacCWeb.Endpoint.broadcast("survey", "update_logs", %{})
          {:noreply, put_flash(socket, :info, "We saved your vote")}
        _ ->
          {:noreply, put_flash(socket, :error, "Ooops .. your vote wasn't save")}
      end
    end
  end

  def handle_info(%{event: "update_logs", payload: payload}, socket) do
    {:noreply,
      socket
      |> assign(:choco_votes_count, Vote.count_choco())
      |> assign(:pac_votes_count, Vote.count_pac())
      |> assign(:votes, Vote.recent_votes())
    }
  end

  defp fetch_user(%{assigns: %{user: user}}), do: user
  defp fetch_user(_), do: nil
end
