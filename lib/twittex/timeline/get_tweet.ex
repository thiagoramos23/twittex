defmodule Twittex.Timeline.GetTweet do
  alias Twittex.Repo
  alias Twittex.Timeline.Queries.GetTweetsQuery

  def call(id, user_id) do
    GetTweetsQuery.build()
    |> GetTweetsQuery.with_user_likes(user_id)
    |> GetTweetsQuery.by_id(id)
    |> Repo.one()
  end
end
