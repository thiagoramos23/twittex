defmodule Twittex.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :text, :text, null: false
      add :action_type, :string, null: false
      add :profile_id, references(:profiles, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:actions, [:profile_id])
  end
end
