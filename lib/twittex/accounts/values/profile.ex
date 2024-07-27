defmodule Twittex.Accounts.Values.Profile do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :name, String.t(), required: true
    field :profile_image_url, String.t()
    field :pid, String.t()
  end

  def from_schema(profile) do
    %__MODULE__{name: profile.name, profile_image_url: profile.profile_image_url, pid: profile.pid}
  end

  def from_map(_params) do
    {:error, :not_implemented}
  end
end
