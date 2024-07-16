defmodule TwittexWeb.TweetLive.TweetCardComponent do
  @moduledoc false
  use TwittexWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="w-auto pt-5 px-5 pb-2 border-2">
      <div class="flex flex-col">
        <div class="flex items-center space-x-2">
          <img src="https://www.w3schools.com/w3images/avatar2.png" class="rounded-full w-10" />
          <span class="font-medium text-pretty">
            <%= @tweet.profile.name %>
          </span>
        </div>
        <div class="ml-12">
          <%= @tweet.text %>
        </div>
      </div>
      <div class="flex justify-start items-center mt-4 space-x-14">
        <.comment tweet={@tweet} />
        <.like tweet={@tweet} index={@index} />
      </div>
      <div :if={length(@tweet.comments) > 0} class="mt-4">
        <span class="font-semibold antialiased">Comments</span>
      </div>
      <div :for={comment <- @tweet.comments} class="mt-4" id="comment-#{comment.id}" class="ml-12">
        <div class="w-auto pt-5 px-5 pb-2 border-2">
          <div class="flex flex-col">
            <div class="flex items-center space-x-2">
              <span class="font-medium text-pretty">
                <%= comment.profile.name %>:
              </span>
            </div>
            <div class="ml-2">
              <%= comment.text %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp like(assigns) do
    ~H"""
    <div phx-click="like" phx-value-tweet-id={@tweet.id} phx-value-index={@index}>
      <.icon :if={not @tweet.liked?} name="hero-heart" class="w-6 h-6 text-gray-500" />
      <.icon :if={@tweet.liked?} name="hero-heart-solid" class="w-6 h-6 bg-red-500" />
      <span class="text-gray-500"><%= @tweet.count_likes %></span>
    </div>
    """
  end

  defp comment(assigns) do
    ~H"""
    <.link navigate={~p"/tweets/#{@tweet.id}/comments/new"}>
      <.icon name="hero-chat-bubble-left" class="w-6 h-6 text-gray-500" />
      <span class="text-gray-500"><%= @tweet.count_comments %></span>
    </.link>
    """
  end
end
