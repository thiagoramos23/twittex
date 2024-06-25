defmodule Twittex.Timeline.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :text, :string
    field :image_url, :string
    belongs_to :user, Twittex.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:text, :image_url, :user_id])
    |> validate_required([:text, :user_id])
  end
end
