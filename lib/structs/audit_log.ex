defmodule Crux.Structs.AuditLog do
  @moduledoc """
  Represents a Discord [Audit Log Object](https://discord.com/developers/docs/resources/audit-log#audit-log-object).
  """
  @moduledoc since: "0.1.6"

  @behaviour Crux.Structs

  alias Crux.Structs.{AuditLog, AuditLogEntry, Integration, Snowflake, User, Util, Webhook}

  defstruct [
    :webhooks,
    :users,
    :integrations,
    :audit_log_entries
  ]

  @typedoc since: "0.1.6"
  @type t :: %__MODULE__{
          webhooks: %{Snowflake.t() => Webhook.t()},
          users: %{Snowflake.t() => User.t()},
          integrations: %{Snowflake.t() => Integration.t()},
          audit_log_entries: %{Snowflake.t() => AuditLogEntry.t()}
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
      |> Map.update(:webhooks, %{}, &Util.raw_data_to_map(&1, Webhook))
      |> Map.update(:users, %{}, &Util.raw_data_to_map(&1, User))
      |> Map.update(:integrations, %{}, &Util.raw_data_to_map(&1, Integration))
      |> Map.update(:audit_log_entries, %{}, &Util.raw_data_to_map(&1, AuditLogEntry))

    struct(__MODULE__, audit_log)
  end
end
