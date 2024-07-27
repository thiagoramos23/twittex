defmodule Twittex.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string, null: false
      add :interests, :text
      add :personality, :text
      add :profile_type, :string, default: ~c"real", null: false
      add :profile_image_url, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:profiles, [:user_id])
    create index(:profiles, [:profile_type])

    create constraint(:profiles, :profile_type, check: "profile_type = ANY('{real,ai}')")
  end
end
