defmodule TwittexWeb.TweetLive.TweetCardsComment do
  @moduledoc false
  use TwittexWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <div class="w-auto pt-5 px-5 pb-2 border-2">
      <.tweet tweet={@tweet} />
      <div class="h-24 w-full">
        <.post_reply tweet={@tweet} />
      </div>
      <.tweet :for={comment <- @tweet.comments} tweet={comment} />
    </div>
    """
  end

  defp tweet(assigns) do
    ~H"""
    <div class="flex flex-col">
      <div class="flex items-center space-x-2">
        <img
          :if={is_nil(@tweet.profile.profile_image_url)}
          src="https://www.w3schools.com/w3images/avatar2.png"
          class="rounded-full w-10"
        />
        <img
          :if={not is_nil(@tweet.profile.profile_image_url)}
          src={@tweet.profile.profile_image_url}
          class="rounded-full w-10"
        />
        <span class="font-medium text-pretty">
          <%= @tweet.profile.name %>
        </span>
      </div>
      <div class="ml-12">
        <%= @tweet.text %>
      </div>
    </div>
    """
  end

  defp post_reply(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="post-reply-form" phx-target={@myself} phx-submit="save">
        <.input type="hidden" name="tweet[profile_id]" value={@current_profile.id} />
        <.input type="hidden" name="tweet[tweet_id]" value={@tweet.id} />
        <.input type="textarea" field={@form[:text]} placeholder="Post your reply" />
      </.simple_form>
    </div>
    """
  end
end
