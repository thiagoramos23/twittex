defmodule TwittexWeb.TestLive.FormComponent do
  use TwittexWeb, :live_component

  alias Twittex.Tests

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage test records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="test-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Test</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{test: test} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tests.change_test(test))
     end)}
  end

  @impl true
  def handle_event("validate", %{"test" => test_params}, socket) do
    changeset = Tests.change_test(socket.assigns.test, test_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"test" => test_params}, socket) do
    save_test(socket, socket.assigns.action, test_params)
  end

  defp save_test(socket, :edit, test_params) do
    case Tests.update_test(socket.assigns.test, test_params) do
      {:ok, test} ->
        notify_parent({:saved, test})

        {:noreply,
         socket
         |> put_flash(:info, "Test updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_test(socket, :new, test_params) do
    case Tests.create_test(test_params) do
      {:ok, test} ->
        notify_parent({:saved, test})

        {:noreply,
         socket
         |> put_flash(:info, "Test created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
