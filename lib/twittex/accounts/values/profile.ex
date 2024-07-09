defmodule Twittex.Accounts.Values.Profile do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :name, String.t(), required: true
  end

  def from_schema(profile) do
    %__MODULE__{name: profile.name}
  end

  def from_map(_params) do
    {:error, :not_implemented}
  end
end
