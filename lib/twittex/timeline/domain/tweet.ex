defmodule Twittex.Timeline.Domain.Tweet do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "tweets" do
    field :text, :string
    field :image_url, :string
    belongs_to :profile, Twittex.Accounts.Profile

    has_many :likes, Twittex.Timeline.Domain.Like
    has_many :comments, Twittex.Timeline.Domain.TweetComment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:text, :image_url, :profile_id])
    |> validate_length(:text, min: 10, max: 300)
    |> validate_required([:text, :profile_id])
  end
end
