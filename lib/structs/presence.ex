defmodule Crux.Structs.Presence do
  @moduledoc """
    Represents a Discord [Presence Object](https://discordapp.com/developers/docs/topics/gateway#presence-update-presence-update-event-fields).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

  alias Crux.Structs.Util
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
