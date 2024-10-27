defmodule TwittexWeb.ProfileLive.Show do
  @moduledoc false
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.Timeline
  alias TwittexWeb.Components.ActionLog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => profile_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:profile, Accounts.get_profile!(profile_id))
     |> stream(:actions, Accounts.list_actions_by_profile(profile_id))
     |> stream(:tweets, Timeline.list_by_profile(profile_id))}
  end
end
