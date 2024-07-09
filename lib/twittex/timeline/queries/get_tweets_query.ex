defmodule Twittex.Timeline.Queries.GetTweetsQuery do
  @moduledoc false
  import Ecto.Query

  alias Twittex.Timeline.Domain.Like
  alias Twittex.Timeline.Domain.Tweet

  def build do
    from tweet in Tweet,
      preload: [:likes, :comments, :profile],
      order_by: [desc: tweet.inserted_at]
  end

  def with_profile_likes(query, profile_id) do
    from tweet in query,
      left_join:
        like in subquery(
          from likes in Like,
            where: likes.profile_id == ^profile_id,
            select: likes
        ),
      on: tweet.id == like.tweet_id,
      select: %{
        tweet: tweet,
        liked: not is_nil(like)
      }
  end

  def by_profile_id(query, profile_id) do
    from tweet in query,
      where: tweet.profile_id == ^profile_id
  end

  def by_id(query, id), do: from(tweet in query, where: tweet.id == ^id)
end
