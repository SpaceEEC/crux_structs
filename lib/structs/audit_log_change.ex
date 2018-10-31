defmodule Crux.Structs.AuditLogChange do
  @moduledoc """
    Represents a Discord [Audit Log Change Object](https://discordapp.com/developers/docs/resources/audit-log#audit-log-change)
  """
  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Overwrite, Role, Util}

  defstruct(
    new_value: nil,
    old_value: nil,
    key: nil
  )

  @type audit_log_change_value :: String.t() | integer() | boolean() | [Role] | [Overwrite]

  @type t :: %__MODULE__{
          new_value: audit_log_change_value() | nil,
          old_value: audit_log_change_value() | nil,
          key: String.t()
        }

  @doc """
    Creates a `Crux.Structs.AuditLogChange` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()

    data =
      case data.key do
        "$add" ->
          data
          |> Map.update(:new_value, nil, &Enum.map(&1, fn role -> Structs.create(role, Role) end))
          |> Map.update(:old_value, nil, &Enum.map(&1, fn role -> Structs.create(role, Role) end))

        "$remove" ->
          data
          |> Map.update(:new_value, nil, &Enum.map(&1, fn role -> Structs.create(role, Role) end))
          |> Map.update(:old_value, nil, &Enum.map(&1, fn role -> Structs.create(role, Role) end))

        "permission_overwrites" ->
          data
          |> Map.update(
            :new_value,
            nil,
            &Enum.map(&1, fn overwrite -> Structs.create(overwrite, Overwrite) end)
          )
          |> Map.update(
            :old_value,
            nil,
            &Enum.map(&1, fn overwrite -> Structs.create(overwrite, Overwrite) end)
          )

        _ ->
          data
      end

    struct(__MODULE__, data)
  end
end
