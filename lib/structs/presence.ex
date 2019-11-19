defmodule Crux.Structs.Presence do
  @moduledoc """
    Represents a Discord [Presence Object](https://discordapp.com/developers/docs/topics/gateway#presence-update-presence-update-event-fields).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Snowflake, User, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    user: nil,
    # roles: [],
    game: nil,
    # guild_id: nil,
    status: "offline",
    activities: [],
    client_status: %{}
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          user: Snowflake.t(),
          # roles: [Snowflake.t()],
          game: map() | nil,
          # guild_id: Snowflake.t() | nil,
          status: String.t(),
          activities: [map()],
          client_status: %{required(atom()) => atom()}
        }

  @typedoc """
    All available types that can be resolved into a user id.
  """
  Util.typesince("0.2.1")
  @type id_resolvable :: User.id_resolvable()

  @doc """
    Resolves the id of a `t:Crux.Structs.Presence.t/0`

  > Automatically invoked by `Crux.Structs.resolve_id/2`

    For examples see `Crux.Structs.User.resolve_id/1`
  """
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  Util.since("0.2.1")

  defdelegate resolve_id(resolvable), to: User

  @doc """
    Creates a `t:Crux.Structs.Presence.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    presence =
      data
      |> Util.atomify()
      |> Map.update!(:user, Util.map_to_id())

    struct(__MODULE__, presence)
  end
end
