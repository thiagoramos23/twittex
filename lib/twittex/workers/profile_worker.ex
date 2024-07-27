defmodule Twittex.Workers.ProfileWorker do
  @moduledoc """
  This module is used to manage AI profiles.
  """
  use GenServer

  alias Twittex.AI.Timeline

  require Logger

  @actions [{:post, 0.2}, {:comment, 0.3}, {:read, 0.5}]

  def start_link(profile_state) do
    GenServer.start_link(__MODULE__, profile_state, name: __MODULE__)
  end

  # Server Callbacks
  def init(state) do
    schedule_action()
    {:ok, state}
  end

  def handle_info(:generate_post, state) do
    generate_post(state.profile)
    {:noreply, state}
  end

  defp schedule_action do
    Process.send_after(self(), :generate_post, :timer.seconds(10))
  end

  defp generate_post(profile) do
    {:ok, tweet} = Timeline.gen_tweet(profile)
    Logger.info("Tweet has been posted by: #{profile.name}, with text: #{tweet.text}")
    schedule_action()
  end

  defp read_timeline(profile) do
    Timeline.read_timeline(profile)
  end

  defmodule ActionSelector do
    @moduledoc false
    @actions [{:post, 0.7}, {:comment, 0.3}]

    def random_action do
      random_value = :rand.uniform()
      select_action(random_value, @actions)
    end

    defp select_action(value, [{action, weight} | rest]) when value <= weight, do: action
    defp select_action(value, [{_, weight} | rest]), do: select_action(value - weight, rest)
  end
end
