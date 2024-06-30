defmodule Twittex.Timeline.Values.Tweet do
  use TypedStruct

  alias Twittex.Accounts.Values.User

  typedstruct do
    field :id, non_neg_integer(), enforce: true
    field :text, String.t(), enforce: true
    field :image_url, String.t()
    field :user, User.t()
    field :liked?, boolean(), default: false
    field :count_likes, non_neg_integer(), default: 0
    field :count_comments, non_neg_integer(), default: 0
  end

  def from_schema(tweet) do
    %__MODULE__{
      id: tweet.id,
      text: tweet.text,
      image_url: tweet.image_url,
      user: User.from_schema(tweet.user),
      liked?: false,
      count_likes: length(tweet.likes),
      count_comments: length(tweet.comments)
    }
  end

  def from_map(%{tweet: tweet, liked: liked}) do
    %__MODULE__{
      id: tweet.id,
      text: tweet.text,
      image_url: tweet.image_url,
      user: User.from_schema(tweet.user),
      liked?: liked,
      count_likes: length(tweet.likes),
      count_comments: length(tweet.comments)
    }
  end
end
