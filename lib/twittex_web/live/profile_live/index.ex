defmodule TwittexWeb.ProfileLive.Index do
  @moduledoc false
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.Accounts.Profile

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :profiles, Accounts.list_profiles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    assign(socket, :profile, Accounts.get_profile!(id))
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, :profile, %Profile{})
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :profile, nil)
  end

  @impl true
  def handle_info({TwittexWeb.ProfileLive.FormComponent, {:saved, profile}}, socket) do
    {:noreply, stream_insert(socket, :profiles, profile)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    profile = Accounts.get_profile!(id)
    {:ok, _} = Accounts.delete_profile(profile)

    {:noreply, stream_delete(socket, :profiles, profile)}
  end
end
