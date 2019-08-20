defmodule Crux.Structs.Overwrite do
  @moduledoc """
    Represents a Discord [Overwrite Object](https://discordapp.com/developers/docs/resources/channel#overwrite-object-overwrite-structure).
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Snowflake, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    id: nil,
    type: nil,
    allow: 0,
    deny: 0
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          id: Snowflake.t(),
          type: String.t(),
          allow: integer(),
          deny: integer()
        }

  @doc """
    Creates a `t:Crux.Structs.Overwrite.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    overwrite =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)

    struct(__MODULE__, overwrite)
  end
end
