defmodule Twittex.Timeline.Values.Tweet do
  @moduledoc false
  use TypedStruct

  alias Twittex.Accounts.Values.Profile

  typedstruct do
    field :id, non_neg_integer(), enforce: true
    field :text, String.t(), enforce: true
    field :image_url, String.t()
    field :profile, Profile.t()
    field :liked?, boolean(), default: false
    field :count_likes, non_neg_integer(), default: 0
    field :count_comments, non_neg_integer(), default: 0
    field :comments, list(__MODULE__.t()), default: []
  end

  def from_schema(tweet) do
    %__MODULE__{
      id: tweet.id,
      text: tweet.text,
      image_url: tweet.image_url,
      profile: Profile.from_schema(tweet.profile),
      liked?: false,
      count_likes: length(tweet.likes),
      count_comments: comments_count(tweet),
      comments: __MODULE__.from_list(tweet.comments)
    }
  end

  def from_map(%{tweet: tweet, liked: liked}) do
    %__MODULE__{
      id: tweet.id,
      text: tweet.text,
      image_url: tweet.image_url,
      profile: Profile.from_schema(tweet.profile),
      liked?: liked,
      count_likes: length(tweet.likes),
      count_comments: comments_count(tweet),
      comments: __MODULE__.from_list(tweet.comments)
    }
  end

  def comments_count(tweet) do
    if Ecto.assoc_loaded?(tweet.comments) do
      length(tweet.comments)
    else
      0
    end
  end

  def from_list(comments) when is_list(comments) do
    Enum.map(comments, &from_schema/1)
  end

  def from_list(_), do: []
end
