defmodule TwittexWeb.TweetCommentLive.Index do
  use TwittexWeb, :live_view

  alias Twittex.Timeline
  alias Twittex.Timeline.Domain.TweetComment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:tweet_comment, nil)
  end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(
      :tweet,
      Timeline.find_tweet_by_id(params["tweet_id"], socket.assigns.current_user.id)
    )
    |> assign(:tweet_comment, %TweetComment{})
  end
end
