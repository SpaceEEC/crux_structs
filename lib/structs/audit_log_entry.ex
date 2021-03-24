defmodule Crux.Structs.AuditLogEntry do
  @moduledoc """
  Represents a Discord [Audit Log Entry Object](https://discord.com/developers/docs/resources/audit-log#audit-log-entry-object).
  """
  @moduledoc since: "0.1.6"

  @behaviour Crux.Structs

  alias Crux.Structs.{AuditLogChange, Snowflake, Util}

  @audit_log_events %{
    guild_update: 1,
    channel_create: 10,
    channel_update: 11,
    channel_delete: 12,
    channel_overwrite_create: 13,
    channel_overwrite_update: 14,
    channel_overwrite_delete: 15,
    member_kick: 20,
    member_prune: 21,
    member_ban_add: 22,
    member_ban_remove: 23,
    member_update: 24,
    member_role_update: 25,
    member_move: 26,
    member_disconnect: 27,
    bot_add: 28,
    role_create: 30,
    role_update: 31,
    role_delete: 32,
    invite_create: 40,
    invite_update: 41,
    invite_delete: 42,
    webhook_create: 50,
    webhook_update: 51,
    webhook_delete: 52,
    emoji_create: 60,
    emoji_update: 61,
    emoji_delete: 62,
    message_delete: 72,
    message_bulk_delete: 73,
    message_pin: 74,
    message_unpin: 75,
    integration_create: 80,
    integration_update: 81,
    integration_delete: 82
  }

  @typedoc """
  Union type of audit log event name atoms.
  """
  @typedoc since: "0.1.6"
  @type event_name ::
          :guild_update
          | :channel_create
          | :channel_update
          | :channel_delete
          | :channel_overwrite_create
          | :channel_overwrite_update
          | :channel_overwrite_delete
          | :member_kick
          | :member_prune
          | :member_ban_add
          | :member_ban_remove
          | :member_update
          | :member_role_update
          | :member_move
          | :member_disconnect
          | :bot_add
          | :role_create
          | :role_update
          | :role_delete
          | :invite_create
          | :invite_update
          | :invite_delete
          | :webhook_create
          | :webhook_update
          | :webhook_delete
          | :emoji_create
          | :emoji_update
          | :emoji_delete
          | :message_delete
          | :message_bulk_delete
          | :message_pin
          | :message_unpin
          | :integration_create
          | :integration_update
          | :integration_delete

  @audit_log_events_key Map.new(@audit_log_events, fn {k, v} -> {v, k} end)

  @doc """
  Returns a map of all audit log event names with their id
  """
  @doc since: "0.1.6"
  @spec events() :: %{event_name => non_neg_integer()}
  def events(), do: @audit_log_events

  @doc """
  Gets the event name from the action type id
  """
  @doc since: "0.1.6"
  @spec event_name(action_type :: non_neg_integer()) :: atom()
  def event_name(action_type), do: Map.get(@audit_log_events_key, action_type)

  defstruct [
    :id,
    :target_id,
    :changes,
    :user_id,
    :action_type,
    :options,
    :reason
  ]

  @typedoc since: "0.1.6"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          target_id: Snowflake.t(),
          changes: %{String.t() => AuditLogChange.t()},
          user_id: Snowflake.t(),
          action_type: non_neg_integer(),
          options: options() | nil,
          reason: String.t() | nil
        }

  @typedoc """
  Additional info for certain action types.

  For more information see the [Discord Developer Documentation](https://discord.com/developers/docs/resources/audit-log#audit-log-entry-object-optional-audit-entry-info).
  """
  @typedoc since: "0.3.0"
  @type options :: %{
          optional(:delete_member_days) => non_neg_integer(),
          optional(:members_removed) => non_neg_integer(),
          optional(:channel_id) => Snowflake.t(),
          optional(:message_id) => Snowflake.t(),
          optional(:count) => non_neg_integer(),
          optional(:id) => Snowflake.t(),
          optional(:type) => non_neg_integer(),
          optional(:role_name) => String.t()
        }

  @doc """
  Creates a `t:Crux.Structs.AuditLogEntry.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.6"
  @spec create(data :: map()) :: t()
  def create(data) do
    audit_log_entry =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update!(:target_id, &Snowflake.to_snowflake/1)
      |> Map.update(:changes, nil, &Util.raw_data_to_map(&1, AuditLogChange, :key))
      |> Map.update!(:user_id, &Snowflake.to_snowflake/1)
      |> Map.update(
        :options,
        nil,
        &Map.new(&1, fn {k, v} ->
          k_string = to_string(k)

          v =
            cond do
              k_string == "id" or binary_part(k_string, byte_size(k_string), -3) == "_id" ->
                Snowflake.to_snowflake(v)

              # The reason type is here -> https://discord.com/developers/docs/change-log#september-24-2020
              k in ~w/type members_removed delete_member_days count/a and not is_integer(v) ->
                String.to_integer(v)

              true ->
                v
            end

          {k, v}
        end)
      )

    struct(__MODULE__, audit_log_entry)
  end
end
