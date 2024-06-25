defmodule Twittex.Timeline do
  import Ecto.Query

  alias Twittex.Timeline.Tweet
  alias Twittex.Repo

  def list(_params \\ %{}, :for_you) do
    Repo.all(from tweet in Tweet, limit: 100, preload: [:user])
  end

  def manage(params, :create_tweet) do
    %Tweet{}
    |> Tweet.changeset(params)
    |> Repo.insert()
  end

  def change_tweet(tweet, params \\ %{}) do
    Tweet.changeset(tweet, params)
  end
end
