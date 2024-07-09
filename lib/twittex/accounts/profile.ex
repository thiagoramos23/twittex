defmodule Twittex.Accounts.Profile do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "profiles" do
    field :name, :string
    field :description, :string
    field :profile_image_url, :string
    belongs_to :user, Twittex.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @required_fields [:name, :user_id]
  @valid_fields @required_fields ++ [:description, :profile_image_url]

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @valid_fields)
    |> validate_required(@required_fields)
  end
end
