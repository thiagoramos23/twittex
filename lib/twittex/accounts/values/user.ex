defmodule Twittex.Accounts.Values.User do
  use TypedStruct

  typedstruct do
    field :id, non_neg_integer(), enforce: true
    field :name, String.t(), enforce: true
    field :email, String.t()
  end

  def from_schema(user) do
    %__MODULE__{id: user.id, name: user.name, email: user.email}
  end

  def from_map(_params) do
    {:error, :not_implemented}
  end
end
