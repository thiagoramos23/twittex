defmodule Twittex.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :text, :text
      add :image_url, :string
      add :profile_id, references(:profiles, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tweets, [:profile_id])
  end
end
