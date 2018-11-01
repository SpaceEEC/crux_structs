defmodule Crux.Structs.AuditLogEntry do
  @moduledoc """
    Represents a Discord [Audit Log Object](https://discordapp.com/developers/docs/resources/audit-log)
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{AuditLogChange, Util}

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
    message_delete: 72
  }

  @typedoc """
    Union type of audit log event name atoms.
  """
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

  @audit_log_events_key Map.new(@audit_log_events, fn {k, v} -> {v, k} end)

  @doc """
    Returns a map of all audit log event names with their id
  """
  @spec events() :: %{event_name => non_neg_integer()}
  def events, do: @audit_log_events

  @doc """
    Gets the event name from the action type id
  """
  @spec event_name(action_type :: non_neg_integer()) :: atom()
  def event_name(action_type), do: Map.get(@audit_log_events_key, action_type)

  defstruct(
    id: nil,
    target_id: nil,
    changes: [],
    user_id: nil,
    action_type: nil,
    options: nil,
    reason: nil
  )

  @type t :: %__MODULE__{
          id: Crux.Rest.snowflake(),
          target_id: Crux.Rest.snowflake(),
          changes: [AuditLogChange.t()],
          user_id: Crux.Rest.snowflake(),
          action_type: non_neg_integer(),
          options: %{} | nil,
          reason: String.t() | nil
        }

  @doc """
    Creates a `Crux.Structs.AuditLogEntry` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)
      |> Map.update!(:target_id, &Util.id_to_int/1)
      |> Map.update(:changes, [], &Structs.create(&1, AuditLogChange))
      |> Map.update!(:user_id, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end
end
