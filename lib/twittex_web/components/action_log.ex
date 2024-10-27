defmodule TwittexWeb.Components.ActionLog do
  @moduledoc false
  use Phoenix.Component

  def show(assigns) do
    ~H"""
    <div>
      <span class="font-bold text-lg">
        <%= @action.profile.name %>:
      </span>
      <span class="font-semibold text-md bg-gray-300 p-1">
      <%= @action.action_type |> Atom.to_string() |> String.split("_") |> Enum.join(" ") %>
    </span>: <%= @action.text %>
    </div>
    """
  end
end
