defmodule Twittex.Tests.Test do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tests" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(test, attrs) do
    test
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
