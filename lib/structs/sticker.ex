defmodule Crux.Structs.Sticker do
  @moduledoc """
  Represents a Discord [Sticker Object](https://discord.com/developers/docs/resources/channel#message-object-message-sticker-structure).
  """
  @moduledoc since: "0.3.0"

  @behaviour Crux.Structs

  alias Crux.Structs.{
    Snowflake,
    Util
  }

  defstruct [
    :id,
    :pack_id,
    :name,
    :description,
    :tags,
    :asset,
    :preview_asset,
    :format_type
  ]

  @typedoc since: "0.3.0"
  @type t :: %{
          id: Snowflake.t(),
          pack_id: Snowflake.t(),
          name: String.t(),
          description: String.t(),
          tags: String.t(),
          asset: String.t(),
          preview_asset: String.t() | nil,
          format_type: 1..3
        }

  def create(data) do
    sticker =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update!(:pack_id, &Snowflake.to_snowflake/1)

    struct(__MODULE__, sticker)
  end
end
