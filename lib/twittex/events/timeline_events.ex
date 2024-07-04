defmodule Twittex.Events.TimelineEvents do
  defmodule TweetCreated do
    defstruct [:user_id, :tweet_id]
  end

  defmodule TweetLiked do
    defstruct [:user_id, :tweet_id]
  end

  defmodule TweetDisliked do
    defstruct [:user_id, :tweet_id]
  end

  defmodule TweetCommented do
    defstruct [:user_id, :tweet_id, :tweet_comment_id]
  end
end
