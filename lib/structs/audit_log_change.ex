defmodule Crux.Structs.AuditLogChange do
  @moduledoc """
    Represents a Discord [Audit Log Change Object](https://discordapp.com/developers/docs/resources/audit-log#audit-log-change)
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Overwrite, Role, Snowflake, Util}
  require Util

  Util.modulesince("0.1.6")

  defstruct(
    new_value: nil,
    old_value: nil,
    key: nil
  )

  @typedoc """
    Represents a value before or after a change.

  > Note that the Role object returned by Discord in audit logs is a partial role that only contains id and name.
  """
  Util.typesince("0.1.6")

  @type audit_log_change_value ::
          String.t()
          | Snowflake.t()
          | integer()
          | boolean()
          | [Role.t()]
          | [Overwrite.t()]

  Util.typesince("0.1.6")

  @type t :: %__MODULE__{
          new_value: audit_log_change_value() | nil,
          old_value: audit_log_change_value() | nil,
          key: String.t()
        }

  @doc """
    Creates a `t:Crux.Structs.AuditLogChange.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.6")

  def create(data) do
    data = Util.atomify(data)

    audit_log_change =
      case data.key do
        "$add" ->
          data
          |> Map.update(:new_value, nil, &Structs.create(&1, Role))
          |> Map.update(:old_value, nil, &Structs.create(&1, Role))

        "$remove" ->
          data
          |> Map.update(:new_value, nil, &Structs.create(&1, Role))
          |> Map.update(:old_value, nil, &Structs.create(&1, Role))

        "permission_overwrites" ->
          data
          |> Map.update(:new_value, nil, &Structs.create(&1, Overwrite))
          |> Map.update(:old_value, nil, &Structs.create(&1, Overwrite))

        # Any key that ends with id is a snowflake
        # Guard is a bit more strict just to be safe
        key when key == "id" or binary_part(key, byte_size(key), -3) == "_id" ->
          data
          |> Map.update(:new_value, nil, &Snowflake.to_snowflake/1)
          |> Map.update(:old_value, nil, &Snowflake.to_snowflake/1)

        _ ->
          data
      end

    struct(__MODULE__, audit_log_change)
  end
end
