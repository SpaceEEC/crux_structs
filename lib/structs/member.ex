defmodule Crux.Structs.Member do
  @moduledoc """
    Represents a Discord [Guild Member Object](https://discordapp.com/developers/docs/resources/guild#guild-member-object-guild-member-structure).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

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

  @doc """
    Creates a `Crux.Structs.Member` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:user, fn user -> Map.get(user, :id) |> Util.id_to_int() end)
      |> Map.update!(:roles, &MapSet.new(&1, fn role_id -> Util.id_to_int(role_id) end))
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end

  @doc ~S"""
    Converts a `Crux.Structs.Member` into its discord mention format.

  ## Examples

    ```elixir
  # Without nickname
  iex> %Crux.Structs.Member{user: 218348062828003328, nick: nil}
  ...> |> Crux.Structs.Member.to_mention()
  "<@218348062828003328>"

  # With nickname
  iex> %Crux.Structs.Member{user: 218348062828003328, nick: "weltraum"}
  ...> |> Crux.Structs.Member.to_mention()
  "<@!218348062828003328>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.Member.t()) :: String.t()
  def to_mention(%__MODULE__{user: id, nick: nil}), do: "<@#{id}>"
  def to_mention(%__MODULE__{user: id}), do: "<@!#{id}>"

  defimpl String.Chars, for: Crux.Structs.Member do
    def to_string(%Crux.Structs.Member{} = data), do: Crux.Structs.Member.to_mention(data)
  end
end
