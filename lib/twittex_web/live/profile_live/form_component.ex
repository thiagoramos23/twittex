defmodule TwittexWeb.ProfileLive.FormComponent do
  @moduledoc false
  use TwittexWeb, :live_component

  alias Twittex.Accounts

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <.simple_form
          for={@form}
          id="profile-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.input type="hidden" name="profile[user_id]" value={@current_user.id} />
          <.input type="hidden" name="profile[profile_type]" value="ai" />
          <div phx-drop-target={@uploads.profile_image.ref}>
            <.live_file_input upload={@uploads.profile_image} />
          </div>
          <div
            :if={not is_nil(@profile.profile_image_url) and @uploads.profile_image.entries == []}
            class="w-48 h-48 my-2"
          >
            <img class="rounded-full" src={@profile.profile_image_url} />
          </div>

          <div :if={@uploads.profile_image.entries != []} class="w-48 h-48 my-2">
            <.live_img_preview entry={hd(@uploads.profile_image.entries)} class="rounded-full" />
          </div>
          <.input field={@form[:name]} type="text" label="Name" />
          <.input
            field={@form[:interests]}
            type="text"
            label="Interests"
            placeholder="movies, arts, music, nature"
          />
          <.input
            field={@form[:personality]}
            type="textarea"
            rows="15"
            label="Personality"
            placeholder="Explain in detail how do you like the personality of this profile to be"
          />
          <:actions>
            <.button phx-disable-with="Saving...">Save Profile</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{profile: profile} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:profile_image, accept: ~w(.jpg .jpeg .png), max_entries: 1)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_profile(profile))
     end)}
  end

  @impl true
  def handle_event("validate", %{"profile" => profile_params}, socket) do
    changeset = Accounts.change_profile(socket.assigns.profile, profile_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"profile" => profile_params}, socket) do
    save_profile(socket, socket.assigns.action, profile_params)
  end

  defp save_profile(socket, :edit, profile_params) do
    profile_params = Map.put(profile_params, "profile_image_url", consume_uploaded_profile(socket))

    case Accounts.update_profile(socket.assigns.profile, profile_params) do
      {:ok, profile} ->
        notify_parent({:saved, profile})

        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_profile(socket, :new, profile_params) do
    profile_params = Map.put(profile_params, "profile_image_url", consume_uploaded_profile(socket))
    IO.inspect(profile_params, label: "PROFILE PARAMS")

    case Accounts.create_profile(profile_params) do
      {:ok, profile} ->
        notify_parent({:saved, profile})

        {:noreply,
         socket
         |> put_flash(:info, "Profile created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error(inspect(changeset))
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp consume_uploaded_profile(socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :profile_image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:twittex), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    if uploaded_files == [], do: nil, else: hd(uploaded_files)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
