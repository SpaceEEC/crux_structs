defmodule Crux.Structs.User do
  @moduledoc """
    Represents a Discord [User Object](https://discordapp.com/developers/docs/resources/user#user-object-user-structure)
  """

  @behaviour Crux.Structs

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

  @doc """
    Creates a `Crux.Structs.User` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end

  @doc ~S"""
    Converts a `Crux.Structs.User` into its discord mention format.

    ```elixir
  iex> %Crux.Structs.User{id: 218348062828003328}
  ...> |> Crux.Structs.User.to_mention()
  "<@218348062828003328>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.User.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<@#{id}>"

  defimpl String.Chars, for: Crux.Structs.User do
    def to_string(%Crux.Structs.User{} = data), do: Crux.Structs.User.to_mention(data)
  end
end
