defmodule Crux.Structs.AuditLog do
  @moduledoc """
  Represents a Discord [Audit Log Object](https://discord.com/developers/docs/resources/audit-log#audit-log-object).
  """
  @moduledoc since: "0.1.6"

  @behaviour Crux.Structs

  alias Crux.Structs.{
    AuditLog,
    AuditLogEntry,
    Channel,
    GuildScheduledEvent,
    Integration,
    Snowflake,
    User,
    Util,
    Webhook
  }

  defstruct [
    :audit_log_entries,
    :guild_scheduled_events,
    :integrations,
    :threads,
    :users,
    :webhooks
  ]

  @typedoc since: "0.1.6"
  @type t :: %__MODULE__{
          audit_log_entries: %{Snowflake.t() => AuditLogEntry.t()},
          guild_scheduled_events: %{Snowflake.t() => GuildScheduledEvent.t()},
          integrations: %{Snowflake.t() => Integration.t()},
          threads: %{Snowflake.t() => Channel.t()},
          users: %{Snowflake.t() => User.t()},
          webhooks: %{Snowflake.t() => Webhook.t()}
        }

  @typedoc """
  All available types that can be resolved into an audit log id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: AuditLog.t() | Snowflake.t() | String.t()

  @doc """
  Creates a `t:Crux.Structs.AuditLog.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.6"
  @spec create(data :: map()) :: t()
  def create(data) do
    audit_log =
      data
      |> Util.atomify()
      |> Map.update(:audit_log_entries, %{}, &Util.raw_data_to_map(&1, AuditLogEntry))
      |> Map.update(:guild_scheduled_events, %{}, &Util.raw_data_to_map(&1, NameOfEventStruct))
      |> Map.update(:integrations, %{}, &Util.raw_data_to_map(&1, Integration))
      |> Map.update(:threads, %{}, &Util.raw_data_to_map(&1, Channel))
      |> Map.update(:users, %{}, &Util.raw_data_to_map(&1, User))
      |> Map.update(:webhooks, %{}, &Util.raw_data_to_map(&1, Webhook))

    struct(__MODULE__, audit_log)
  end
end
