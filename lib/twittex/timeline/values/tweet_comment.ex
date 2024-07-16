defmodule Twittex.Timeline.Values.TweetComment do
  @moduledoc false
  use TypedStruct

  alias Twittex.Accounts.Values.Profile

  typedstruct do
    field :id, non_neg_integer(), enforce: true
    field :text, String.t(), enforce: true
    field :profile, Profile.t()
  end

  def from_schema(comment) do
    %__MODULE__{
      id: comment.id,
      text: comment.text,
      profile: Profile.from_schema(comment.profile)
    }
  end

  def from_map(_) do
    {:error, :not_implemented}
  end

  def from_list(comments) do
    Enum.map(comments, &from_schema/1)
  end
end
