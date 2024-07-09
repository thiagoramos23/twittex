defmodule TwittexWeb.TweetCommentLive.FormComponent do
  @moduledoc false
  use TwittexWeb, :live_component

  alias Twittex.Timeline

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:text]} type="textarea" label="Add your Comment" />
        <:actions>
          <.button phx-disable-with="Adding your comment...">Comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tweet_comment: tweet_comment} = assigns, socket) do
    changeset = Timeline.change_tweet_comment(tweet_comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tweet_comment" => tweet_comment_params}, socket) do
    changeset =
      socket.assigns.tweet_comment
      |> Timeline.change_tweet_comment(tweet_comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tweet_comment" => tweet_comment_params}, socket) do
    save_tweet_comment(socket, socket.assigns.action, tweet_comment_params)
  end

  defp save_tweet_comment(socket, :new, tweet_comment_params) do
    tweet_comment_params =
      Map.merge(tweet_comment_params, %{
        "profile_id" => socket.assigns.current_profile.id,
        "tweet_id" => socket.assigns.tweet.id
      })

    case Timeline.manage(tweet_comment_params, :create_tweet_comment) do
      {:ok, _tweet_comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
