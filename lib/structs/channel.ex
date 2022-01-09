defmodule Crux.Structs.Channel do
  @moduledoc """
  Represents a Discord [Channel Object](https://discord.com/developers/docs/resources/channel#channel-object).
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Channel, Message, Overwrite, Snowflake, Util}

  defstruct [
    :id,
    :type,
    :guild_id,
    :position,
    :permission_overwrites,
    :name,
    :topic,
    :nsfw,
    :last_message_id,
    :bitrate,
    :user_limit,
    :rate_limit_per_user,
    :recipients,
    :icon,
    :owner_id,
    :application_id,
    :parent_id,
    :last_pin_timestamp,
    :rtc_region,
    :video_quality_mode,
    :message_count,
    :member_count,
    :thread_metadata,
    :member,
    :default_auto_archive_duration
    # :permissions - Interaction only
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          application_id: Snowflake.t(),
          bitrate: integer(),
          guild_id: Snowflake.t(),
          icon: String.t(),
          id: Snowflake.t(),
          last_message_id: Snowflake.t(),
          last_pin_timestamp: String.t(),
          name: String.t(),
          nsfw: boolean(),
          owner_id: Snowflake.t(),
          parent_id: Snowflake.t(),
          permission_overwrites: %{optional(Snowflake.t()) => Overwrite.t()},
          position: integer(),
          rate_limit_per_user: integer(),
          recipients: MapSet.t(Snowflake.t()),
          topic: String.t(),
          type: type(),
          user_limit: non_neg_integer(),
          rtc_region: String.t(),
          video_quality_mode: 1 | 2,
          message_count: 1..50,
          member_count: 1..50,
          thread_metadata: thread_metadata(),
          member: thread_member(),
          default_auto_archive_duration: 60 | 1440 | 4320 | 10_080
        }

  @typedoc """
  Additional metadata for threads.

  For more information see the [Discord Developer Documentation](https://discord.com/developers/docs/resources/channel#thread-metadata-object-thread-metadata-structure).
  """
  @typedoc since: "0.3.0"
  @type thread_metadata :: %{
          optional(:invitable) => boolean(),
          archived: boolean(),
          auto_archive_duration: 60 | 1440 | 4320 | 10_080,
          archive_timestamp: String.t(),
          locked: boolean()
        }

  @typedoc """
  A thread member.

  Notes:
  - `:id` -> Id of the thread, not member / user
  - `:user_id` -> Acutal id of the member / user

  For more information see the [Discord Developer Documentation](https://discord.com/developers/docs/resources/channel#thread-member-object-thread-member-structure).
  """
  @typedoc since: "0.3.0"
  @type thread_member :: %{
          id: Snowflake.t(),
          user_id: Snowflake.t(),
          join_timestamp: String.t(),
          flags: integer()
        }

  @typedoc """
  The type of a channel.

  | Type                 | ID  | Description                                                                                                             |
  | :------------------: | :-: | :---------------------------------------------------------------------------------------------------------------------: |
  | GUILD_TEXT           |  0  | A text channel within a guild.                                                                                          |
  | DM                   |  1  | A direct text channel between two users.                                                                                |
  | GUILD_VOICE          |  2  | A voice channel withing a guild.                                                                                        |
  | GROUP_DM             |  3  | A direct channel between multiple users. Bots do not have access to those.                                              |
  | GUILD_CATEGORY       |  4  | An organizational category.                                                                                             |
  | GUILD_NEWS           |  5  | A text channel users can follow and crosspost messages to.                                                              |
  | GUILD_STORE          |  6  | A channel in which game developers can sell their game. Bots can not interact with those.                               |
  | GUILD_NEWS_THREAD    | 10  | A temporary sub-channel within a GUILD_NEWS channel                                                                     |
  | GUILD_PUBLIC_THREAD  | 11  | A temporay sub-channel within a GUILD_TEXT channel                                                                      |
  | GUILD_PRIVATE_THREAD | 12  | A temporary sub-channel within a GUILD_TEXT channel only viewable by invited and members with MANAGE_THREADS permission |
  | GUILD_STAGE_VOICE    | 13  | A voice channel for hosting events with an audience                                                                     |

  For more information see the [Discord Developer Documentation](https://discord.com/developers/docs/resources/channel#channel-object-channel-types).
  """
  @typedoc since: "0.2.3"
  @type type :: non_neg_integer()

  @typedoc """
  All available types that can be resolved into a channel id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Message.t() | Channel.t() | Snowflake.t() | String.t()

  @doc """
  Resolves the id of a `t:Crux.Structs.Channel.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

  ```elixir
  iex> %Crux.Structs.Message{channel_id: 222079895583457280}
  ...> |> Crux.Structs.Channel.resolve_id()
  222079895583457280

  iex> %Crux.Structs.Channel{id: 222079895583457280}
  ...> |> Crux.Structs.Channel.resolve_id()
  222079895583457280

  iex> 222079895583457280
  ...> |> Crux.Structs.Channel.resolve_id()
  222079895583457280

  iex> "222079895583457280"
  ...> |> Crux.Structs.Channel.resolve_id()
  222079895583457280

  ```
  """
  @doc since: "0.2.3"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  def resolve_id(%Message{channel_id: channel_id}) do
    resolve_id(channel_id)
  end

  def resolve_id(%Channel{id: id}) do
    resolve_id(id)
  end

  def resolve_id(resolvable), do: Structs.resolve_id(resolvable)

  @typedoc """
  All available types that can be resolved into a channel position.
  """
  @typedoc since: "0.2.1"
  @type position_resolvable() ::
          Channel.t()
          | %{channel: id_resolvable(), position: integer()}
          | {id_resolvable(), integer()}
          | %{id: id_resolvable(), position: integer()}

  @doc """
  Resolves a `t:position_resolvable/0` into a channel position.

  ## Examples

  ```elixir
  iex> %Crux.Structs.Channel{id: 222079895583457280, position: 5}
  ...> |> Crux.Structs.Channel.resolve_position()
  %{id: 222079895583457280, position: 5}

  iex> {%Crux.Structs.Channel{id: 222079895583457280}, 5}
  ...> |> Crux.Structs.Channel.resolve_position()
  %{id: 222079895583457280, position: 5}

  iex> {222079895583457280, 5}
  ...> |> Crux.Structs.Channel.resolve_position()
  %{id: 222079895583457280, position: 5}

  iex> %{id: 222079895583457280, position: 5}
  ...> |> Crux.Structs.Channel.resolve_position()
  %{id: 222079895583457280, position: 5}

  iex> %{channel: 222079895583457280, position: 5}
  ...> |> Crux.Structs.Channel.resolve_position()
  %{id: 222079895583457280, position: 5}

  iex> {nil, 5}
  ...> |> Crux.Structs.Channel.resolve_position()
  nil

  ```
  """
  @doc since: "0.2.1"
  @spec resolve_position(position_resolvable()) :: %{id: Snowflake.t(), position: integer()} | nil
  def resolve_position(resolvable)

  def resolve_position(%Channel{id: id, position: position}) do
    validate_position(%{id: id, position: position})
  end

  def resolve_position(%{channel: resolvable, position: position}) do
    validate_position(%{id: resolve_id(resolvable), position: position})
  end

  def resolve_position(%{id: resolvable, position: position}) do
    validate_position(%{id: resolve_id(resolvable), position: position})
  end

  def resolve_position({resolvable, position}) do
    validate_position(%{id: resolve_id(resolvable), position: position})
  end

  @doc false
  @spec validate_position(%{id: Snowflake.t(), position: integer()}) :: %{
          id: Snowflake.t(),
          position: integer()
        }
  @spec validate_position(%{id: nil, position: integer()}) :: nil
  defp validate_position(%{id: nil, position: _}), do: nil

  defp validate_position(%{id: _id, position: position} = entry)
       when is_integer(position) do
    entry
  end

  @doc """
  Creates a `t:Crux.Structs.Channel.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`
  """
  @typedoc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    channel =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:owner_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:last_message_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:application_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:parent_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:permission_overwrites, nil, &Util.raw_data_to_map(&1, Overwrite))
      |> Map.update(:recipients, nil, &MapSet.new(&1, Util.map_to_id()))

    struct(__MODULE__, channel)
  end

  @doc ~S"""
  Converts a `t:Crux.Structs.Channel.t/0` into its discord mention format.

  ## Example

  ```elixir
  iex> %Crux.Structs.Channel{id: 316880197314019329}
  ...> |> Crux.Structs.Channel.to_mention()
  "<#316880197314019329>"

  ```
  """
  @doc since: "0.1.1"
  @spec to_mention(user :: Channel.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<##{id}>"

  defimpl String.Chars, for: Crux.Structs.Channel do
    @spec to_string(Channel.t()) :: String.t()
    def to_string(%Channel{} = data), do: Channel.to_mention(data)
  end
end
