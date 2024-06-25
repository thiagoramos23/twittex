defmodule TwittexWeb.TweetLive.Index do
  use TwittexWeb, :live_view

  alias Twittex.Timeline.Tweet

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:tweets, Twittex.Timeline.list(:for_you))
     |> stream(:logs, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:tweet, nil)
  end

  defp apply_action(socket, :new, _params) do
    IO.inspect("TESTE", label: "TEST")

    socket
    |> assign(:tweet, %Tweet{})
  end
end
