defmodule Crux.Structs.Role do
  @moduledoc """
    Represents a Discord [Role Object](https://discordapp.com/developers/docs/topics/permissions#role-object-role-structure).
  """

  @behaviour Crux.Structs

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
          id: Crux.Rest.snowflake(),
          name: String.t(),
          color: integer(),
          hoist: boolean(),
          position: integer(),
          permissions: integer(),
          managed: boolean(),
          mentionable: boolean(),
          guild_id: Crux.Rest.snowflake()
        }

  @doc """
    Creates a `Crux.Structs.Role` struct from raw data.

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
    Converts a `Crux.Structs.Role` into its discord mention format.

    ## Example

    ```elixir
  iex> %Crux.Structs.Role{id: 376146940762783746}
  ...> |> Crux.Structs.Role.to_mention()
  "<@&376146940762783746>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.Role.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<@&#{id}>"

  defimpl String.Chars, for: Crux.Structs.Role do
    def to_string(%Crux.Structs.Role{} = data), do: Crux.Structs.Role.to_mention(data)
  end
end
