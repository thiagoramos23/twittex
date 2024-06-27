defmodule Twittex.Timeline do
  import Ecto.Query

  alias Twittex.Timeline.Values.Tweet, as: TweetValue
  alias Twittex.Repo
  alias Twittex.Timeline.Domain.Like
  alias Twittex.Timeline.Domain.Tweet
  alias Twittex.Timeline.GetTweets

  def list(params, :for_you) do
    result = GetTweets.call(params)
    Enum.map(result, &TweetValue.from_map/1)
  end

  def manage(params, :create_tweet) do
    %Tweet{}
    |> Tweet.changeset(params)
    |> Repo.insert()
  end

  def manage(%{user: user, tweet_id: tweet_id}, :toggle_like) do
    liked_tweet = liked_tweet(user.id, tweet_id)

    if liked_tweet do
      Repo.delete(liked_tweet)
    else
      %Like{}
      |> Like.changeset(%{user_id: user.id, tweet_id: tweet_id})
      |> Repo.insert()
    end
  end

  def change_tweet(tweet, params \\ %{}) do
    Tweet.changeset(tweet, params)
  end

  defp liked_tweet(user_id, tweet_id) do
    Repo.one(
      from likes in Like, where: likes.user_id == ^user_id, where: likes.tweet_id == ^tweet_id
    )
  end
end
