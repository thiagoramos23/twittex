defmodule TwittexWeb.TweetLive.TweetCardComponent do
  use TwittexWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="w-auto pt-5 px-5 pb-2 border-2">
      <div class="flex flex-col">
        <div class="flex items-center space-x-2">
          <img src="https://www.w3schools.com/w3images/avatar2.png" class="rounded-full w-10" />
          <span class="font-medium text-pretty">
            <%= @tweet.user.email %>
          </span>
        </div>
        <div class="ml-12">
          <%= @tweet.text %>
        </div>
      </div>
      <div class="flex justify-start items-center mt-4 space-x-14">
        <.icon name="hero-chat-bubble-left" class="w-6 h-6 text-gray-400" />
        <.icon name="hero-heart" class="w-6 h-6 text-gray-400" />
      </div>
    </div>
    """
  end
end
