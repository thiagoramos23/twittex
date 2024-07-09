defmodule Twittex.Accounts.Values.User do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :id, non_neg_integer(), enforce: true
    field :email, String.t()
  end

  def from_schema(user) do
    %__MODULE__{id: user.id, email: user.email}
  end

  def from_map(_params) do
    {:error, :not_implemented}
  end
end
