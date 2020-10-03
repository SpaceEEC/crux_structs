defmodule Crux.Structs.Embed do
  @moduledoc """
  Represents a Discord [Embed Object](https://discord.com/developers/docs/resources/channel#embed-object).

  Every property except type is optional, and thus may have default value.
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  defstruct [
    :title,
    :type,
    :description,
    :url,
    :timestamp,
    :color,
    :footer,
    :image,
    :thumbnail,
    :video,
    :provider,
    :author,
    :fields
  ]

  @typedoc since: "0.1.0"
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
