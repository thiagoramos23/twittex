defmodule Twittex.Timeline.Domain.Like do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "likes" do
    belongs_to :profile, Twittex.Accounts.Profile
    belongs_to :tweet, Twittex.Timeline.Tweet

    timestamps(type: :utc_datetime)
  end

  @required_fields [:profile_id, :tweet_id]

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
