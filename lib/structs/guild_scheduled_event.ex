defmodule Crux.Structs.GuildScheduledEvent do
  @moduledoc """
  Represents a Discord [Guild Scheduled Event Object](https://discord.com/developers/docs/resources/guild-scheduled-event#guild-scheduled-event-object).
  """
  @moduledoc since: "0.3.0"

  @behaviour Crux.Structs

  alias Crux.Structs.{
    Snowflake,
    Util
  }

  defstruct [
    :id,
    :guild_id,
    :channel_id,
    :creator_id,
    :name,
    :description,
    :scheduled_start_time,
    :scheduled_end_time,
    :privacy_level,
    :status,
    :entity_type,
    :entity_id,
    :entity_metadata,
    # :creator,
    :user_count
  ]

  @typedoc since: "0.3.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          guild_id: Snowflake.t(),
          channel_id: Snowflake.t() | nil,
          creator_id: Snowflake.t() | nil,
          name: String.t(),
          description: String.t(),
          scheduled_start_time: String.t(),
          scheduled_end_time: String.t() | nil,
          privacy_level: 2,
          status: 1..4,
          entity_type: 1..3,
          entity_id: Snowflake.t() | nil,
          entity_metadata: %{optional(:location) => String.t()} | nil,
          # creator: User.t(),
          user_count: non_neg_integer()
        }

  @doc since: "0.3.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:creator_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:entity_id, nil, &Snowflake.to_snowflake/1)

    struct(__MODULE__, data)
  end
end
