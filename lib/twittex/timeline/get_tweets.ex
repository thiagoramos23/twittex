defmodule Twittex.Timeline.GetTweets do
  alias Twittex.Timeline.Queries.GetTweetsQuery
  alias Twittex.Repo

  def call(%{user_id: user_id}) do
    GetTweetsQuery.build()
    |> GetTweetsQuery.with_user_likes(user_id)
    |> Repo.all()
  end
end
