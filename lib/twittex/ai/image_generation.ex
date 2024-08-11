defmodule Twittex.Ai.ImageGeneration do
  @moduledoc """
  This module generates image from text using DALL-E
  """

  def generate_image(text_prompt) do
    openai_key = Application.fetch_env!(:twittex, :openai_key)
    url = Application.fetch_env!(:openai, :create_image_url)

    {request, response} =
      [
        method: :post,
        url: url,
        auth: {:bearer, openai_key},
        json: %{model: "dall-e-2", n: 1, prompt: text_prompt, size: "512x512"}
      ]
      |> Req.new()
      |> Req.Request.put_header("content-type", "application/json")
      |> Req.Steps.auth()
      |> Req.Request.run_request()
  end
end
