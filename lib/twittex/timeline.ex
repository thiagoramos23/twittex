defmodule Twittex.Timeline do
  @moduledoc false
  import Ecto.Query

  alias Twittex.Events.TimelineEvents.TweetCommented
  alias Twittex.Events.TimelineEvents.TweetCreated
  alias Twittex.Events.TimelineEvents.TweetDisliked
  alias Twittex.Events.TimelineEvents.TweetLiked
  alias Twittex.Repo
  alias Twittex.Timeline.Domain.Like
  alias Twittex.Timeline.Domain.Tweet
  alias Twittex.Timeline.Domain.TweetComment
  alias Twittex.Timeline.GetTweet
  alias Twittex.Timeline.GetTweets
  alias Twittex.Timeline.Values.Tweet, as: TweetValue

  @pubsub Twittex.PubSub
  @topic "tweets"

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def list(params, :all) do
    result = GetTweets.call(params)
    Enum.map(result, &TweetValue.from_map/1)
  end

  def manage(params, :create_tweet) do
    %Tweet{}
    |> Tweet.changeset(params)
    |> Repo.insert()
    |> broadcast(:tweet_created)
  end

  def manage(params, :create_tweet_comment) do
    %TweetComment{}
    |> TweetComment.changeset(params)
    |> Repo.insert()
    |> broadcast(:tweet_commented)
  end

  def manage(%{profile: profile, tweet_id: tweet_id}, :toggle_like) do
    like_for_tweet = get_like_for_tweet(profile.id, tweet_id)

    if like_for_tweet do
      Repo.delete(like_for_tweet, returning: true)
      broadcast({:ok, %Like{profile_id: profile.id, tweet_id: tweet_id}}, :tweet_disliked)
    else
      %Like{}
      |> Like.changeset(%{profile_id: profile.id, tweet_id: tweet_id})
      |> Repo.insert()
      |> broadcast(:tweet_liked)
    end
  end

  def find_tweet_by_id(id, profile_id) do
    result = GetTweet.call(id, profile_id)
    TweetValue.from_map(result)
  end

  def change_tweet(tweet, params \\ %{}) do
    Tweet.changeset(tweet, params)
  end

  def change_tweet_comment(tweet_comment, params \\ %{}) do
    TweetComment.changeset(tweet_comment, params)
  end

  defp get_like_for_tweet(profile_id, tweet_id) do
    Repo.one(
      from likes in Like,
        where: likes.profile_id == ^profile_id,
        where: likes.tweet_id == ^tweet_id
    )
  end

  defp broadcast({:ok, tweet}, :tweet_created) do
    broadcast!(%TweetCreated{profile_id: tweet.profile_id, tweet_id: tweet.id})
    {:ok, tweet}
  end

  defp broadcast({:ok, tweet_comment}, :tweet_commented) do
    broadcast!(%TweetCommented{
      profile_id: tweet_comment.profile_id,
      tweet_id: tweet_comment.tweet_id,
      tweet_comment_id: tweet_comment.id
    })

    {:ok, tweet_comment}
  end

  defp broadcast({:ok, like}, :tweet_liked) do
    broadcast!(%TweetLiked{profile_id: like.profile_id, tweet_id: like.tweet_id})
    {:ok, like}
  end

  defp broadcast({:ok, like}, :tweet_disliked) do
    broadcast!(%TweetDisliked{profile_id: like.profile_id, tweet_id: like.tweet_id})
    {:ok, like}
  end

  defp broadcast({:error, reason}, _event), do: {:error, reason}

  defp broadcast!(message) do
    Phoenix.PubSub.broadcast!(@pubsub, @topic, {__MODULE__, message})
  end
end
