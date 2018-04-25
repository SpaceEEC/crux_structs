defmodule Crux.Structs.Embed do
  @moduledoc """
  Represents a Discord [Embed Object](https://discordapp.com/developers/docs/resources/channel#embed-object-embed-structure).

  Every property except type is optional, and thus may have default value.
  """

  defstruct(
    title: nil,
    type: "rich",
    description: nil,
    url: nil,
    timestamp: nil,
    color: nil,
    footer: nil,
    image: nil,
    thumbnail: nil,
    video: nil,
    provider: nil,
    author: nil,
    fields: []
  )

  @type t :: %__MODULE__{
          title: String.t() | nil,
          type: String.t() | nil,
          description: String.t() | nil,
          url: String.t() | nil,
          timestamp: String.t() | nil,
          color: integer() | nil,
          footer:
            %{
              optional(:text) => String.t(),
              optional(:icon_url) => String.t(),
              optional(:proxy_icon_url) => String.t()
            }
            | nil,
          image:
            %{
              optional(:url) => String.t(),
              optional(:proxy_url) => String.t(),
              optional(:height) => integer(),
              optional(:width) => integer()
            }
            | nil,
          thumbnail:
            %{
              optional(:url) => String.t(),
              optional(:proxy_url) => String.t(),
              optional(:height) => integer(),
              optional(:width) => integer()
            }
            | nil,
          video:
            %{
              optional(:url) => String.t(),
              optional(:height) => integer(),
              optional(:width) => integer()
            }
            | nil,
          provider:
            %{
              optional(:name) => String.t(),
              optional(:url) => String.t()
            }
            | nil,
          author:
            %{
              optional(:name) => String.t(),
              optional(:url) => String.t(),
              optional(:icon_url) => String.t(),
              optional(:proxy_icon_url) => String.t()
            }
            | nil,
          fields: [
            %{
              required(:name) => String.t(),
              required(:value) => String.t(),
              optional(:inline) => boolean()
            }
          ]
        }
end
