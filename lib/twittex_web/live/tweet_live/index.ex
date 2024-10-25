defmodule TwittexWeb.TweetLive.Index do
  @moduledoc false
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.AI.Profile
  alias Twittex.Events.TimelineEvents
  alias Twittex.Timeline
  alias Twittex.Timeline.Domain.Tweet
  alias Twittex.Workers.ProfileSupervisor

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Timeline.subscribe()
    end

    tweets = get_tweets(socket)

    {:ok,
     socket
     |> stream_configure(:tweets, dom_id: &"tweets-#{&1.id}")
     |> stream(:tweets, tweets)
     |> stream(:logs, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("start_ai", _params, socket) do
    {:ok, profile} = start_ai_profile(socket.assigns.current_profile)
    {:noreply, assign(socket, :current_profile, profile)}
  end

  @impl true
  def handle_event("start_all_ai", _params, socket) do
    Enum.each(Accounts.list_all_ai_profiles(), fn profile ->
      start_ai_profile(profile)
    end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop_all_ai", _params, socket) do
    stop_all_ai_profiles()
    {:noreply, socket}
  end

  @impl true
  def handle_event("like", %{"tweet-id" => tweet_id, "index" => tweet_index}, socket) do
    case Timeline.manage(%{tweet_id: tweet_id, profile: socket.assigns.current_profile}, :toggle_like) do
      {:ok, like} ->
        tweet = Timeline.find_tweet_by_id(like.tweet_id, socket.assigns.current_profile.id)
        {:noreply, stream_insert(socket, :tweets, tweet, at: tweet_index)}

      {:error, _error} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({Timeline, %TimelineEvents.TweetCreated{tweet_id: tweet_id}}, socket) do
    update_timeline(tweet_id, socket, at: 0)
  end

  @impl true
  def handle_info({Timeline, %TimelineEvents.TweetLiked{tweet_id: tweet_id}}, socket) do
    update_timeline(tweet_id, socket)
  end

  @impl true
  def handle_info({Timeline, %TimelineEvents.TweetDisliked{tweet_id: tweet_id}}, socket) do
    update_timeline(tweet_id, socket)
  end

  @impl true
  def handle_info({Timeline, %TimelineEvents.TweetCommented{parent_tweet_id: parent_tweet_id}}, socket) do
    update_timeline(parent_tweet_id, socket)
  end

  defp update_timeline(tweet_id, socket, opts \\ []) do
    tweet = Timeline.find_tweet_by_id(tweet_id, socket.assigns.current_profile.id)
    {:noreply, stream_insert(socket, :tweets, tweet, opts)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :tweet, nil)
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, :tweet, %Tweet{})
  end

  defp apply_action(socket, :show_comments, %{"tweet_id" => tweet_id}) do
    tweet = Twittex.Timeline.find_tweet_by_id(tweet_id, socket.assigns.current_profile.id)
    assign(socket, :tweet, tweet)
  end

  defp get_tweets(socket) do
    params = %{profile_id: socket.assigns.current_profile.id}
    Twittex.Timeline.list(params, :all)
  end

  defp start_ai_profile(profile) do
    Profile.start(profile.id)
  end

  defp stop_all_ai_profiles do
    ProfileSupervisor.stop_all_profiles()
  end
end
