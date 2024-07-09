defmodule Twittex.Timeline.GetTweet do
  @moduledoc false
  alias Twittex.Repo
  alias Twittex.Timeline.Queries.GetTweetsQuery

  def call(id, profile_id) do
    GetTweetsQuery.build()
    |> GetTweetsQuery.with_profile_likes(profile_id)
    |> GetTweetsQuery.by_id(id)
    |> Repo.one()
  end
end
