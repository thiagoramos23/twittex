defmodule TwittexWeb.ActionLive.Index do
  @moduledoc false
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias TwittexWeb.Components.ActionLog

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Accounts.subscribe()
    end

    actions = get_all_actions()

    {:ok, stream(socket, :actions, actions)}
  end

  @impl true
  def handle_info({:action_created, action}, socket) do
    {:noreply, stream_insert(socket, :actions, action, at: 0)}
  end

  defp get_all_actions do
    Accounts.get_all_actions()
  end
end
