defmodule TwittexWeb.TweetLive.Index do
  use TwittexWeb, :live_view

  alias Twittex.Timeline
  alias Twittex.Timeline.Domain.Tweet

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:tweets, get_tweets(socket))
     |> stream(:logs, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event(
        "like",
        %{"tweet-id" => tweet_id, "index" => tweet_index},
        socket
      ) do
    case Timeline.manage(%{tweet_id: tweet_id, user: socket.assigns.current_user}, :toggle_like) do
      {:ok, like} ->
        tweet = Timeline.find_tweet_by_id(like.tweet_id, socket.assigns.current_user.id)
        {:noreply, socket |> stream_insert(:tweets, tweet, at: tweet_index)}

      {:error, _error} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({TwittexWeb.TweetLive.FormComponent, {:saved, tweet}}, socket) do
    tweet = Timeline.find_tweet_by_id(tweet.id, socket.assigns.current_user.id)
    {:noreply, socket |> stream_insert(:tweets, tweet, at: 0)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:tweet, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:tweet, %Tweet{})
  end

  defp get_tweets(socket) do
    params = %{user_id: socket.assigns.current_user.id}
    Twittex.Timeline.list(params, :all)
  end
end
