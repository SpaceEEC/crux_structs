defmodule Crux.Structs.AuditLog do
  @moduledoc """
    Represents a Discord [Audit Log Object](https://discordapp.com/developers/docs/resources/audit-log#audit-log-object)
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{AuditLogEntry, User, Util, Webhook}

  defstruct(
    webhooks: nil,
    users: nil,
    audit_log_entries: nil
  )

  @type t :: %__MODULE__{
          webhooks: [Webhook.t()],
          users: [User.t()],
          audit_log_entries: [AuditLogEntry.t()]
        }

  @doc """
    Creates a `Crux.Structs.AuditLog` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(
        :webhooks,
        [],
        &Enum.map(&1, fn webhook -> Structs.create(webhook, Webhook) end)
      )
      |> Map.update(
        :users,
        [],
        &Enum.map(&1, fn user -> Structs.create(user, User) end)
      )
      |> Map.update(
        :audit_log_entries,
        [],
        &Enum.map(&1, fn entry -> Structs.create(entry, AuditLogEntry) end)
      )

    struct(__MODULE__, data)
  end
end
