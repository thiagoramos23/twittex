defmodule Twittex.Timeline.GetTweets do
  import Ecto.Query

  alias Twittex.Timeline.Domain.Tweet
  alias Twittex.Timeline.Domain.Like
  alias Twittex.Repo

  def call(%{user_id: user_id}) do
    query =
      from tweet in Tweet,
        left_join:
          like in subquery(
            from likes in Like,
              where: likes.user_id == ^user_id,
              select: likes
          ),
        on: tweet.id == like.tweet_id,
        preload: [:user, :likes],
        select: %{
          tweet: tweet,
          liked: not is_nil(like)
        }

    Repo.all(query)
  end
end
