defmodule Crux.Structs.User do
  @moduledoc """
    Represents a Discord [User Object](https://discordapp.com/developers/docs/resources/user#user-object-user-structure)
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Snowflake, User, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    avatar: nil,
    bot: false,
    discriminator: nil,
    id: nil,
    username: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          avatar: String.t() | nil,
          bot: boolean(),
          discriminator: String.t(),
          id: Snowflake.t(),
          username: String.t()
        }

  @doc """
    Creates a `t:Crux.Structs.User.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    user =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)

    struct(__MODULE__, user)
  end

  @doc ~S"""
    Converts a `t:Crux.Structs.User.t/0` into its discord mention format.

    ```elixir
  iex> %Crux.Structs.User{id: 218348062828003328}
  ...> |> Crux.Structs.User.to_mention()
  "<@218348062828003328>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.User.t()) :: String.t()
  Util.since("0.1.1")
  def to_mention(%__MODULE__{id: id}), do: "<@#{id}>"

  defimpl String.Chars, for: Crux.Structs.User do
    @spec to_string(User.t()) :: String.t()
    def to_string(%User{} = data), do: User.to_mention(data)
  end
end
