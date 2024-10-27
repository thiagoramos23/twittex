defmodule Twittex.Accounts.Action do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "actions" do
    field :text, :string
    field :action_type, Ecto.Enum, values: [:waking_up, :post, :read_timeline, :read_comments, :why_comment, :comment]
    belongs_to :profile, Twittex.Accounts.Profile

    timestamps(type: :utc_datetime)
  end

  @required_fields [:text, :profile_id, :action_type]

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
