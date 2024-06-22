defmodule TwittexWeb.TweetLive.Index do
  use TwittexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div :for={{tweet, _i} <- @streams.tweets} id={"#{tweet.id}"}>
      <%= tweet_card(tweet = tweet) %>
    </div>
    """
  end

  def tweet_card(assigns) do
    ~H"""
    <div class="w-auto p-5 border-2">
      <div class="flex flex-col">
        <div class="flex items-center space-x-2">
          <img src="https://www.w3schools.com/w3images/avatar2.png" class="rounded-full w-10" />
          <span class="font-medium text-pretty">
            <%= @tweet.user.name %>
          </span>
        </div>
        <div class="ml-12">
          <%= @tweet.text %>
        </div>
      </div>
    </div>
    """
  end
end
