defmodule Twittex.Workers.ProfileSupervisor do
  @moduledoc """
  This is the module that supervises all the profile servers.
  """

  use DynamicSupervisor

  alias Twittex.Workers.ProfileWorker

  require Logger

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_child(profile) do
    spec = {ProfileWorker, %{profile: profile}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_args) do
    Logger.info("Profile Supervisor is starting...")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
