defmodule Twittex.Timeline.GetTweets do
  @moduledoc false
  alias Twittex.Repo
  alias Twittex.Timeline.Queries.GetTweetsQuery

  def call(%{profile_id: profile_id}) do
    GetTweetsQuery.build()
    |> GetTweetsQuery.with_profile_likes(profile_id)
    |> GetTweetsQuery.that_are_no_replies()
    |> Repo.all()
  end
end
