defmodule Twittex.Repo.Migrations.AddLastCommentTweetId do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :last_comment_tweet_id, references(:tweets, on_delete: :nothing)
    end

    create index(:profiles, [:last_comment_tweet_id])
  end
end
