defmodule Twittex.Events.TimelineEvents do
  @moduledoc false
  defmodule TweetCreated do
    @moduledoc false
    defstruct [:profile_id, :tweet_id]
  end

  defmodule TweetLiked do
    @moduledoc false
    defstruct [:profile_id, :tweet_id]
  end

  defmodule TweetDisliked do
    @moduledoc false
    defstruct [:profile_id, :tweet_id]
  end

  defmodule TweetCommented do
    @moduledoc false
    defstruct [:profile_id, :parent_tweet_id, :tweet_id]
  end
end
