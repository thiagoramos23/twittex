defmodule Twittex.Repo.Migrations.CreateTweetComments do
  use Ecto.Migration

  def change do
    create table(:tweet_comments) do
      add :text, :text
      add :tweet_id, references(:tweets, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :parent_comment_id, references(:tweet_comments, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tweet_comments, [:tweet_id])
    create index(:tweet_comments, [:user_id])
    create index(:tweet_comments, [:parent_comment_id])
  end
end
