defmodule Twittex.Workers.ProfileSupervisor do
  @moduledoc """
  This is the module that supervises all the profile servers.
  """

  use DynamicSupervisor

  alias Twittex.Accounts
  alias Twittex.Workers.ProfileWorker

  require Logger

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Logger.info("Profile Supervisor is starting...")
    Accounts.reset_all_pids()
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_profile_ai(profile) do
    spec = {ProfileWorker, %{profile: profile}}
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, spec)
    Logger.info("Profile Supervisor started #{profile.name} with pid #{inspect(pid)}")
    {:ok, pid}
  end
end
