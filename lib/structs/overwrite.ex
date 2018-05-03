defmodule Crux.Structs.Overwrite do
  @moduledoc """
    Represents a Discord [Overwrite Object](https://discordapp.com/developers/docs/resources/channel#overwrite-object-overwrite-structure).
  """

  @behaviour Crux.Structs

  alias Crux.Structs.Util

  defstruct(
    id: nil,
    type: nil,
    allow: 0,
    deny: 0
  )

  @type t :: %__MODULE__{
          id: integer(),
          type: String.t(),
          allow: integer(),
          deny: integer()
        }

  @doc """
    Creates a `Crux.Structs.Overwrite` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end
end
