defmodule Crux.Structs.AuditLog do
  @moduledoc """
    Represents a Discord [Audit Log Object](https://discordapp.com/developers/docs/resources/audit-log#audit-log-object)
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{AuditLogEntry, User, Util, Webhook}

  defstruct(
    webhooks: %{},
    users: %{},
    audit_log_entries: %{}
  )

  @type t :: %__MODULE__{
          webhooks: %{Crux.Rest.snowflake() => Webhook.t()},
          users: %{Crux.Rest.snowflake() => User.t()},
          audit_log_entries: %{Crux.Rest.snowflake() => AuditLogEntry.t()}
        }

  @doc """
    Creates a `Crux.Structs.AuditLog` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:webhooks, [], &Util.raw_data_to_map(&1, Webhook))
      |> Map.update(:users, [], &Util.raw_data_to_map(&1, User))
      |> Map.update(:audit_log_entries, [], &Util.raw_data_to_map(&1, AuditLogEntry))

    struct(__MODULE__, data)
  end
end
