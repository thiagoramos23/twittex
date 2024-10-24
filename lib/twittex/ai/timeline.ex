defmodule Twittex.AI.Timeline do
  @moduledoc """
  This module exists so we can generate tweets and comments using AI.
  """
  import Ecto.Query

  alias Twittex.Accounts
  alias Twittex.Repo
  alias Twittex.Timeline
  alias Twittex.Timeline.Domain.Tweet

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
    Logger.info("#{profile.name} is thinking about making a comment to the tweet from #{tweet.profile.name}")

    {:ok, tweet_embedded} =
      Instructor.chat_completion(
        model: "gpt-4",
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
            Before generating a comment, you should think about your persona: '#{profile.personality}'
            Think about a comment that is relevant for the discussion about the tweet: '#{tweet.text}'
            but also matches your persona.

            Based on all of the information above, your tweet_text is:
            """
          }
        ]
      )

    Logger.info("#{profile.name} made a comment to the #{tweet.profile.name} tweet saying: #{tweet_embedded.tweet_text}")

    case Timeline.manage(
           %{profile_id: profile.id, text: tweet_embedded.tweet_text, parent_tweet_id: tweet.id},
           :create_tweet_comment
         ) do
      {:ok, _} ->
        Accounts.update_profile(profile, %{last_comment_tweet_id: tweet.id})

      {:error, reason} ->
        Logger.error(reason)
    end
  end

  def gen_tweet(profile) do
    Logger.info("#{profile.name} is thinking about making a tweet...")

    {:ok, tweet_embedded} =
      Instructor.chat_completion(
        model: "gpt-4",
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
            - You should never start by saying As a Guru or As an expert or any other expressions similar to that.

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
    profile
    |> get_tweets_to_read_query()
    |> Repo.all()
    |> Enum.reduce_while(:ok, fn tweet, acc ->
      Logger.info("#{profile.name} is reading the timeline. Right now reading the tweet from #{tweet.profile.name}")
      probability = check_intersests(profile, tweet)

      if probability > 0.5 do
        Logger.info("#{profile.name} found that the tweet from #{tweet.profile.name} matches their interests")
        gen_comment(profile, tweet)
        {:halt, acc}
      else
        {:cont, acc}
      end
    end)
  end

  def read_comments_in_your_posts(profile) do
    profile
    |> get_comments_in_your_posts()
    |> Enum.reduce_while(:ok, fn tweet, acc ->
      Logger.info(
        "#{profile.name} is reading comments made in your posts. Right now reading the comment from #{tweet.profile.name}"
      )

      probability = check_intersests(profile, tweet)

      if probability > 0.7 do
        Logger.info("#{profile.name} found that the tweet from #{tweet.profile.name} matches their interests")
        gen_comment(profile, tweet)
        {:halt, acc}
      else
        {:cont, acc}
      end
    end)
  end

  defp check_intersests(profile, tweet) do
    Logger.info("#{profile.name} is checking tweets to see if it's interested...")

    result =
      Instructor.chat_completion(
        model: "gpt-4",
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
            A post will match your interests if it has similarities to the #{profile.interests}.
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

  defp get_comments_in_your_posts(profile) do
    query =
      from(tweet in Tweet,
        as: :tweet,
        where: tweet.profile_id == ^profile.id,
        where: is_nil(tweet.parent_tweet_id)
      )

    Repo.all(
      from comments in Tweet,
        join: tweets in subquery(query),
        on: comments.parent_tweet_id == tweets.id,
        preload: [:profile]
    )
  end

  defp get_tweets_to_read_query(profile) do
    query =
      from(tweet in Tweet,
        as: :tweet,
        where: tweet.profile_id != ^profile.id,
        where: is_nil(tweet.parent_tweet_id),
        order_by: [desc: tweet.inserted_at],
        limit: 10,
        preload: [:profile]
      )

    if profile.last_comment_tweet_id,
      do: where(query, [tweet: tweet], tweet.id != ^profile.last_comment_tweet_id),
      else: query
  end
end
