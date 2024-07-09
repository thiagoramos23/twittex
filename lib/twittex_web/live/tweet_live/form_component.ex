defmodule TwittexWeb.TweetLive.FormComponent do
  @moduledoc false
  use TwittexWeb, :live_component

  alias Twittex.Timeline

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:text]} type="textarea" label="Tweet" />
        <:actions>
          <.button phx-disable-with="Generating...">Post your Tweet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tweet: tweet} = assigns, socket) do
    changeset = Timeline.change_tweet(tweet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tweet" => tweet_params}, socket) do
    changeset =
      socket.assigns.tweet
      |> Timeline.change_tweet(tweet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tweet" => tweet_params}, socket) do
    save_tweet(socket, socket.assigns.action, tweet_params)
  end

  defp save_tweet(socket, :new, tweet_params) do
    tweet_params = Map.put(tweet_params, "profile_id", socket.assigns.current_profile.id)

    case Timeline.manage(tweet_params, :create_tweet) do
      {:ok, _tweet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tweet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
