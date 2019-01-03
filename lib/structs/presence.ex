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
          user: Crux.Rest.snowflake(),
          # roles: [Crux.Rest.snowflake()],
          game: map() | nil,
          # guild_id: Crux.Rest.snowflake() | nil,
          status: String.t(),
          activities: [map()],
          client_status: %{required(atom()) => atom()}
        }

  @doc """
    Creates a `Crux.Structs.Presence` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  Util.since("0.1.0")

  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:user, fn user -> Map.get(user, :id) |> Util.id_to_int() end)

    struct(__MODULE__, data)
  end
end
