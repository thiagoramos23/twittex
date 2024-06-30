defmodule Twittex.Timeline do
  import Ecto.Query

  alias Twittex.Timeline.Values.Tweet, as: TweetValue
  alias Twittex.Repo
  alias Twittex.Timeline.Domain.Like
  alias Twittex.Timeline.Domain.Tweet
  alias Twittex.Timeline.Domain.TweetComment
  alias Twittex.Timeline.GetTweets
  alias Twittex.Timeline.GetTweet

  def list(params, :all) do
    result = GetTweets.call(params)
    Enum.map(result, &TweetValue.from_map/1)
  end

  def manage(params, :create_tweet) do
    %Tweet{}
    |> Tweet.changeset(params)
    |> Repo.insert()
  end

  def manage(params, :create_tweet_comment) do
    %TweetComment{}
    |> TweetComment.changeset(params)
    |> Repo.insert()
  end

  def manage(%{user: user, tweet_id: tweet_id}, :toggle_like) do
    like_for_tweet = get_like_for_tweet(user.id, tweet_id)

    if like_for_tweet do
      Repo.delete(like_for_tweet, returning: true)
    else
      %Like{}
      |> Like.changeset(%{user_id: user.id, tweet_id: tweet_id})
      |> Repo.insert()
    end
  end

  def find_tweet_by_id(id, user_id) do
    result = GetTweet.call(id, user_id)
    TweetValue.from_map(result)
  end

  def change_tweet(tweet, params \\ %{}) do
    Tweet.changeset(tweet, params)
  end

  def change_tweet_comment(tweet_comment, params \\ %{}) do
    TweetComment.changeset(tweet_comment, params)
  end

  defp get_like_for_tweet(user_id, tweet_id) do
    Repo.one(
      from likes in Like,
        where: likes.user_id == ^user_id,
        where: likes.tweet_id == ^tweet_id
    )
  end
end
