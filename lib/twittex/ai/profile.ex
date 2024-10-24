defmodule Twittex.AI.Profile do
  @moduledoc """
  This module initializes the AI profile being passed in the params
  """
  alias Twittex.Accounts
  alias Twittex.Workers.ProfileSupervisor

  def start(profile_id) do
    profile_id
    |> Accounts.get_profile!()
    |> ProfileSupervisor.start_profile_ai()
  end
end
