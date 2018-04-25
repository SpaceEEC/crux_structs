defmodule Crux.Structs.Member do
  @moduledoc """
    Represents a Discord [Guild Member Object](https://discordapp.com/developers/docs/resources/guild#guild-member-object-guild-member-structure).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  alias Crux.Structs.Util

  defstruct(
    user: nil,
    nick: nil,
    roles: nil,
    joined_at: nil,
    deaf: nil,
    mute: nil,
    guild_id: nil
  )

  @type t :: %__MODULE__{
          user: integer(),
          nick: String.t() | nil,
          roles: MapSet.t(integer()),
          joined_at: String.t(),
          deaf: boolean() | nil,
          mute: boolean() | nil,
          guild_id: integer() | nil
        }

  @doc false
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:user, fn user -> Map.get(user, :id) |> Util.id_to_int() end)
      |> Map.update!(:roles, &MapSet.new(&1, fn role_id -> Util.id_to_int(role_id) end))
      |> Map.update!(:guild_id, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end
end
