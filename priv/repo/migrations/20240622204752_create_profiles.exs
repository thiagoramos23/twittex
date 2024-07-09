defmodule Twittex.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string, null: false
      add :description, :text
      add :profile_image_url, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:profiles, [:user_id])
  end
end
