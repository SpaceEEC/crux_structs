defmodule Crux.Structs.Emoji do
  @moduledoc """
  Represents a Discord [Emoji Object](https://discordapp.com/developers/docs/resources/emoji#emoji-object-emoji-structure).
  """

  alias Crux.Structs.Util

  defstruct(
    animated: nil,
    id: nil,
    name: nil,
    roles: nil,
    user: nil,
    require_colons: nil,
    managed: nil
  )

  @type t :: %__MODULE__{
          animated: boolean(),
          id: integer(),
          name: String.t(),
          roles: MapSet.t(integer()),
          user: integer(),
          require_colons: boolean(),
          managed: boolean()
        }

  @doc false
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Util.id_to_int/1)
      |> Map.update(:roles, [], &MapSet.new(&1, fn role -> Util.id_to_int(role) end))
      |> Map.update(:user, nil, fn user -> Map.get(user, :id) |> Util.id_to_int() end)

    struct(__MODULE__, data)
  end
end
