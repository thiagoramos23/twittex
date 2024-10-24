defmodule Twittex.Accounts.Thought do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "thoughts" do
    field :text, :string
    belongs_to :profile, Twittex.Accounts.Profile

    timestamps(type: :utc_datetime)
  end

  @required_fields [:text, :profile_id]

  @doc false
  def changeset(thought, attrs) do
    thought
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
