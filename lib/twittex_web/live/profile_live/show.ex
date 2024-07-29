defmodule TwittexWeb.ProfileLive.Show do
  @moduledoc false
  use TwittexWeb, :live_view

  alias Twittex.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply, assign(socket, :profile, Accounts.get_profile!(id))}
  end
end
