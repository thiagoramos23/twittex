defmodule TwittexWeb.TweetLive.Index do
  use TwittexWeb, :live_view

  alias Twittex.Timeline
  alias Twittex.Timeline.Domain.Tweet

  @impl true
  def mount(_params, _session, socket) do
    params = %{user_id: socket.assigns.current_user.id}

    {:ok,
     socket
     |> stream(:tweets, Twittex.Timeline.list(params, :for_you))
     |> stream(:logs, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event(
        "like",
        %{"tweet-id" => tweet_id, "index" => _tweet_index},
        socket
      ) do
    case Timeline.manage(%{tweet_id: tweet_id, user: socket.assigns.current_user}, :toggle_like) do
      {:ok, _liked_tweet} ->
        {:noreply, socket}

      {:error, _error} ->
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:tweet, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:tweet, %Tweet{})
  end
end
