defmodule Crux.Structs.User do
  @moduledoc """
    Represents a Discord [User Object](https://discordapp.com/developers/docs/resources/user#user-object-user-structure)
  """

  alias Crux.Structs.Util

  defstruct(
    avatar: nil,
    bot: false,
    discriminator: nil,
    id: nil,
    username: nil
  )

  @type t :: %__MODULE__{
          avatar: String.t() | nil,
          bot: boolean(),
          discriminator: String.t(),
          id: integer(),
          username: String.t()
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
