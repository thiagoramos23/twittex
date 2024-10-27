defmodule Twittex.Timeline.GetTweetByProfile do
  @moduledoc false
  alias Twittex.Repo
  alias Twittex.Timeline.Queries.GetTweetsQuery

  def call(profile_id) do
    GetTweetsQuery.build()
    |> GetTweetsQuery.by_profile_id(profile_id)
    |> Repo.all()
  end
end
