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
    :type,
    :format_type,
    :available,
    :guild_id,
    :user,
    :sort_value
  ]

  @typedoc since: "0.3.0"
  @type t :: %{
          id: Snowflake.t(),
          pack_id: Snowflake.t(),
          name: String.t(),
          description: String.t(),
          tags: String.t(),
          type: 1..2,
          format_type: 1..3,
          available: boolean() | nil,
          guild_id: Snowflake.t() | nil,
          user: Snowflake.t() | nil,
          sort_value: integer() | nil
        }

  @typedoc """
  The smallest amount of data required to render a sticker.

  Used in messages.

  For more information see the [Discord Developer Documentation](https://discord.com/developers/docs/resources/sticker#sticker-item-object).
  """
  @typedoc since: "0.3.0"
  @type sticker_item :: %{
          id: Snowflake.t(),
          name: String.t(),
          formate_type: 1..3
        }

  @typedoc """
  All available types that can be resolved into a sticker id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Role.t() | Snowflake.t() | String.t() | nil

  def create(data) do
    sticker =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update!(:pack_id, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:user, nil, Util.map_to_id())

    struct(__MODULE__, sticker)
  end
end
