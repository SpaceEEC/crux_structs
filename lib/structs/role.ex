defmodule Crux.Structs.Role do
  @moduledoc """
    Represents a Discord [Role Object](https://discordapp.com/developers/docs/topics/permissions#role-object-role-structure).
  """

  alias Crux.Structs.Util

  defstruct(
    id: nil,
    name: nil,
    color: nil,
    hoist: nil,
    position: nil,
    permissions: nil,
    managed: nil,
    mentionable: nil,
    guild_id: nil
  )

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          color: integer(),
          hoist: boolean(),
          position: integer(),
          permissions: integer(),
          managed: boolean(),
          mentionable: boolean(),
          guild_id: integer()
        }

  @doc false
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)

      struct(__MODULE__, data)
  end
end
