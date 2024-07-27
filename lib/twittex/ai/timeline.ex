defmodule Twittex.AI.Timeline do
  @moduledoc """
  This module exists so we can generate tweets and comments using AI.
  """
  import Ecto.Query

  alias Twittex.Repo
  alias Twittex.Timeline

  require Logger

  defmodule TweetEmbed do
    @moduledoc false
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:tweet_text, :string)
    end
  end

  defmodule ProfileMatchProbability do
    @moduledoc false
    use Ecto.Schema

    @doc """
    ## Field Descriptions:
    - match_probability: 0.0 - 1.0. Is the probability that the tweet text will be similar to the user profile interests
    """
    @primary_key false
    embedded_schema do
      field(:match_probability, :float)
    end

    def validate_changeset(changeset) do
      Ecto.Changeset.validate_number(changeset, :match_probability,
        greater_than_or_equal_to: 0.0,
        less_than_or_equal_to: 1.0
      )
    end
  end

  def gen_comment(profile, tweet) do
    Logger.info("#{profile.name} is thinking about making a comment to the tweet: #{tweet.text}")

    {:ok, tweet_embedded} =
      Instructor.chat_completion(
        model: "gpt-3.5-turbo",
        response_model: TweetEmbed,
        messages: [
          %{
            role: "user",
            content: """
            system: You are a user of a social platform (like Twitter).
            In this moment you are commenting on a post.
            - The post text is '#{tweet.text}'.

            Comments are max 400 characters and can contain one or multiple sentences and can or not
            have hashtags. You can either agree or disagree and if you disagree you can be brutally honest.
            Either way you should try to explain your opinion but not too much.
            Generate a comment using your personality wich is: '#{profile.personality}'

            Your tweet_text is:
            """
          }
        ]
      )

    Timeline.manage(%{profile_id: profile.id, text: tweet_embedded.tweet_text, tweet_id: tweet.id}, :create_tweet_comment)
  end

  def gen_tweet(profile) do
    Logger.info("#{profile.name} is thinking about making a tweet...")

    {:ok, tweet_embedded} =
      Instructor.chat_completion(
        model: "gpt-3.5-turbo",
        response_model: TweetEmbed,
        messages: [
          %{
            role: "user",
            content: """
            system: You are a user of a social platform (like Twitter).
            Here it is some information about you:
            - Your name is: '#{profile.name}'.
            - You like to talk about: '#{profile.interests}'.
            - Your personality and the way you write is: '#{profile.personality}'.

            In this moment you are tweeting a new tweet.
            - Your tweets should always follow the topics and subjects you love and also show your personality.
            - The topics you love are: #{profile.interests}
            - You personality is: #{profile.personality}

            Tweets are max 240 characters and can contain one or multiple sentences and can or not
            have hashtags. You should express your opinions about the topics you love or hate.

            Your tweet_text is:
            """
          }
        ]
      )

    Timeline.manage(%{profile_id: profile.id, text: tweet_embedded.tweet_text}, :create_tweet)
  end

  def read_timeline(profile) do
    from(tweet in Twittex.Timeline.Domain.Tweet, order_by: [desc: tweet.inserted_at], limit: 10)
    |> Repo.all()
    |> Enum.each(fn tweet ->
      Logger.info("#{profile.name} is reading the timeline. Right now reading the tweet '#{tweet.text}'")
      probability = check_intersests(profile, tweet)

      if probability > 0.4 do
        Logger.info("#{profile.name} found that the tweet '#{tweet.text}' matches their interests")
        gen_comment(profile, tweet)
      end
    end)
  end

  defp check_intersests(profile, tweet) do
    Logger.info("#{profile.name} is thinking about making a tweet...")

    result =
      Instructor.chat_completion(
        model: "gpt-3.5-turbo",
        response_model: ProfileMatchProbability,
        messages: [
          %{
            role: "user",
            content: """
            system: You are a user of a social platform (like Twitter).
            Here it is some information about you:
            - Your name is: '#{profile.name}'.
            - You like to talk about: '#{profile.interests}'.
            - Your personality and the way you write is: '#{profile.personality}'.

            In this moment you are reading a post in the platform.
            You need to decide how much this post will match your interests.
            You should use a scale of 0.0 to 1.0 where 0.0 means that the post does not match your interests at all
            and 1.0 means that the post matches your interests perfectly.

            This is the post text: '#{tweet.text}'

            Your match_probability is:
            """
          }
        ]
      )

    case result do
      {:ok, probability} ->
        probability

      {:error, reason} ->
        Logger.error(reason)
        0.0
    end
  end
end
