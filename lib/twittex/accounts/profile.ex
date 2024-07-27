defmodule Twittex.Accounts.Profile do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "profiles" do
    field :name, :string
    field :description, :string
    field :interests, :string
    field :personality, :string
    field :profile_image_url, :string
    field :profile_type, Ecto.Enum, values: [:real, :ai]
    belongs_to :user, Twittex.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @required_fields [:name, :user_id]
  @valid_fields @required_fields ++ [:description, :profile_image_url, :interests, :personality, :profile_type]

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @valid_fields)
    |> validate_inclusion(:profile_type, [:real, :ai])
    |> validate_required(@required_fields)
  end
end
