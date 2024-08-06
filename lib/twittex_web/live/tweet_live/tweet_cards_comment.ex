defmodule TwittexWeb.TweetLive.TweetCardsComment do
  @moduledoc false
  use TwittexWeb, :live_component

  alias Twittex.Timeline
  alias Twittex.Timeline.Domain.Tweet

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-auto pt-5 px-5 pb-2 border-2">
      <.tweet tweet={@tweet} />
      <div class="w-full mb-5">
        <.post_reply tweet={@tweet} form={@form} myself={@myself} current_profile={@current_profile} />
      </div>
      <div :if={@tweet.count_comments > 0} id="tweet_comments" phx-update="stream">
        <.tweet :for={{_id, comment} <- @streams.comments} tweet={comment} />
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = Timeline.change_tweet(%Tweet{})
    %{tweet: tweet} = assigns

    {:ok,
     socket
     |> assign(assigns)
     |> stream(:comments, tweet.comments)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("save", %{"tweet" => tweet_params}, socket) do
    case Timeline.manage(tweet_params, :create_tweet_comment) do
      {:ok, tweet} ->
        tweet = Timeline.find_tweet_by_id(tweet.id, socket.assigns.current_profile.id)
        {:noreply, stream_insert(socket, :comments, tweet, at: 0)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp tweet(assigns) do
    ~H"""
    <div id={"comments-#{@tweet.id}"} class="flex flex-col mt-3">
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
        <.input type="hidden" name="tweet[parent_tweet_id]" value={@tweet.id} />
        <.input type="textarea" field={@form[:text]} placeholder="Post your reply" />
        <:actions>
          <.button phx-disable-with="Tweeting...">Post your Reply</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
