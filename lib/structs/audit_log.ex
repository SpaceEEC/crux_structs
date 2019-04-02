defmodule Crux.Structs.AuditLog do
  @moduledoc """
    Represents a Discord [Audit Log Object](https://discordapp.com/developers/docs/resources/audit-log#audit-log-object)
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{AuditLogEntry, User, Util, Webhook}
  require Util

  Util.modulesince("0.1.6")

  defstruct(
    webhooks: %{},
    users: %{},
    audit_log_entries: %{}
  )

  Util.typesince("0.1.6")

  @type t :: %__MODULE__{
          webhooks: %{Crux.Rest.snowflake() => Webhook.t()},
          users: %{Crux.Rest.snowflake() => User.t()},
          audit_log_entries: %{Crux.Rest.snowflake() => AuditLogEntry.t()}
        }

  @doc """
    Creates a `Crux.Structs.AuditLog` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.6")

  def create(data) do
    audit_log =
      data
      |> Util.atomify()
      |> Map.update(:webhooks, [], &Util.raw_data_to_map(&1, Webhook))
      |> Map.update(:users, [], &Util.raw_data_to_map(&1, User))
      |> Map.update(:audit_log_entries, [], &Util.raw_data_to_map(&1, AuditLogEntry))

    struct(__MODULE__, audit_log)
  end
end
