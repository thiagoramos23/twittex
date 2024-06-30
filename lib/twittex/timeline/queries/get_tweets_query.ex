defmodule Twittex.Timeline.Queries.GetTweetsQuery do
  import Ecto.Query

  alias Twittex.Timeline.Domain.Tweet
  alias Twittex.Timeline.Domain.Like

  def build do
    from tweet in Tweet,
      preload: [:user, :likes, :comments],
      order_by: [desc: tweet.inserted_at]
  end

  def with_user_likes(query, user_id) do
    from tweet in query,
      left_join:
        like in subquery(
          from likes in Like,
            where: likes.user_id == ^user_id,
            select: likes
        ),
      on: tweet.id == like.tweet_id,
      select: %{
        tweet: tweet,
        liked: not is_nil(like)
      }
  end

  def by_user_id(query, user_id) do
    from tweet in query,
      where: tweet.user_id == ^user_id
  end

  def by_id(query, id), do: from(tweet in query, where: tweet.id == ^id)
end
