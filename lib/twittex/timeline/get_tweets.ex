defmodule Twittex.Timeline.GetTweets do
  @moduledoc false
  alias Twittex.Repo
  alias Twittex.Timeline.Queries.GetTweetsQuery

  def call(%{user_id: user_id}) do
    GetTweetsQuery.build()
    |> GetTweetsQuery.with_profile_likes(user_id)
    |> Repo.all()
  end
end
