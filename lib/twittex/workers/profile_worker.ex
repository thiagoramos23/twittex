defmodule Twittex.Workers.ProfileWorker do
  @moduledoc """
  This module is used to manage AI profiles.
  """
  use GenServer

  alias Twittex.Accounts
  alias Twittex.AI.Timeline
  alias Twittex.Workers.ProfileWorker.ActionSelector

  def start_link(profile_state) do
    {:ok, pid} = GenServer.start_link(__MODULE__, profile_state)
    save_action(profile_state.profile, :waking_up, [])
    {:ok, pid}
  end

  # Server Callbacks
  def init(state) do
    schedule_action()
    {:ok, state}
  end

  def handle_info(:post, state) do
    generate_post(state.profile)
    {:noreply, state}
  end

  def handle_info(:sleep, state) do
    schedule_action(5)
    {:noreply, state}
  end

  def handle_info(:read, state) do
    read_timeline(state.profile)
    schedule_action(20)
    {:noreply, state}
  end

  def handle_info(:read_comments, state) do
    read_comments(state.profile)
    schedule_action(20)
    {:noreply, state}
  end

  def handle_info(:choose_action, state) do
    action = ActionSelector.random_action()
    Process.send_after(self(), action, :timer.seconds(1))
    {:noreply, state}
  end

  defp schedule_action(seconds \\ 15) do
    Process.send_after(self(), :choose_action, :timer.seconds(seconds))
  end

  defp generate_post(profile) do
    {:ok, _tweet} = Timeline.gen_tweet(profile)
    schedule_action()
  end

  defp read_timeline(profile) do
    Timeline.read_timeline(profile)
    save_action(profile, :read_timeline, [])
  end

  defp read_comments(profile) do
    Timeline.read_comments_in_your_posts(profile)
    save_action(profile, :read_comments, [])
  end

  defp save_action(profile, :waking_up, _opts) do
    Accounts.create_action(%{profile_id: profile.id, action_type: :waking_up, text: "Profile is waking up..."})
  end

  defp save_action(profile, :read_comments, _opts) do
    Accounts.create_action(%{
      profile_id: profile.id,
      action_type: :read_comments,
      text: "Profile is reading comments in their posts..."
    })
  end

  defp save_action(profile, :read_timeline, _opts) do
    Accounts.create_action(%{
      profile_id: profile.id,
      action_type: :read_timeline,
      text: "Profile is reading the timeline..."
    })
  end

  defmodule ActionSelector do
    @moduledoc false
    @actions [{:post, 0, 0.20}, {:sleep, 0.21, 0.50}, {:read, 0.51, 0.75}, {:read_comments, 0.76, 1.0}]

    def random_action do
      random_value = :rand.uniform()

      Enum.reduce_while(@actions, :sleep, fn {action, min, max}, acc ->
        if random_value >= min && random_value < max do
          {:halt, action}
        else
          {:cont, acc}
        end
      end)
    end
  end
end
