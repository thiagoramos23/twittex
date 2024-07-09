defmodule Twittex.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :profile_id, references(:profiles, on_delete: :nothing)
      add :tweet_id, references(:tweets, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:likes, [:profile_id])
    create index(:likes, [:tweet_id])
  end
end
