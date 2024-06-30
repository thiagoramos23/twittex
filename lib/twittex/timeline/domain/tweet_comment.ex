defmodule Twittex.Timeline.Domain.TweetComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweet_comments" do
    field :text, :string
    belongs_to :user, Twittex.Accounts.User
    belongs_to :tweet, Twittex.Timeline.Tweet
    belongs_to :parent_comment, __MODULE__

    timestamps(type: :utc_datetime)
  end

  @required_fields [:text, :user_id, :tweet_id]
  @doc false
  def changeset(tweet_comment, attrs) do
    tweet_comment
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
