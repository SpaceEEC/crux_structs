defmodule Crux.Structs.AuditLogEntry do
  @moduledoc """
    Represents a Discord [Audit Log Entry Object](https://discordapp.com/developers/docs/resources/audit-log#audit-log-entry-object).
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{AuditLogChange, Snowflake, Util}
  require Util

  Util.modulesince("0.1.6")

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
  Util.typesince("0.1.6")

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
  @spec events() :: %{event_name => non_neg_integer()}
  Util.since("0.1.6")
  def events(), do: @audit_log_events

  @doc """
    Gets the event name from the action type id
  """
  @spec event_name(action_type :: non_neg_integer()) :: atom()
  Util.since("0.1.6")
  def event_name(action_type), do: Map.get(@audit_log_events_key, action_type)

  defstruct(
    id: nil,
    target_id: nil,
    changes: %{},
    user_id: nil,
    action_type: nil,
    options: nil,
    reason: nil
  )

  Util.typesince("0.1.6")

  @type t :: %__MODULE__{
          id: Snowflake.t(),
          target_id: Snowflake.t(),
          changes: %{String.t() => AuditLogChange.t()},
          user_id: Snowflake.t(),
          action_type: non_neg_integer(),
          options: %{} | nil,
          reason: String.t() | nil
        }

  @doc """
    Creates a `t:Crux.Structs.AuditLogEntry.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.6")

  def create(data) do
    audit_log_entry =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update!(:target_id, &Snowflake.to_snowflake/1)
      |> Map.update(:changes, %{}, &Util.raw_data_to_map(&1, AuditLogChange, :key))
      |> Map.update!(:user_id, &Snowflake.to_snowflake/1)
      |> Map.update(
        :options,
        nil,
        &Map.new(&1, fn {k, v} ->
          k_string = to_string(k)

          v =
            if k_string == "id" or binary_part(k_string, byte_size(k_string), -3) == "_id" do
              Snowflake.to_snowflake(v)
            else
              v
            end

          {k, v}
        end)
      )

    struct(__MODULE__, audit_log_entry)
  end
end
