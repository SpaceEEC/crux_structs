defmodule Crux.Structs.Emoji do
  @moduledoc """
  Represents a Discord [Emoji Object](https://discordapp.com/developers/docs/resources/emoji#emoji-object-emoji-structure).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

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
          animated: boolean() | nil,
          id: Crux.Rest.snowflake() | nil,
          name: String.t(),
          roles: MapSet.t(Crux.Rest.snowflake()),
          user: Crux.Rest.snowflake() | nil,
          require_colons: boolean() | nil,
          managed: boolean() | nil
        }

  @doc """
    Creates a `Crux.Structs.Emoji` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Util.id_to_int/1)
      |> Map.update(:roles, MapSet.new(), &MapSet.new(&1, fn role -> Util.id_to_int(role) end))
      |> Map.update(:user, nil, fn user -> Map.get(user, :id) |> Util.id_to_int() end)

    struct(__MODULE__, data)
  end

  @doc ~S"""
    Converts an `Crux.Structs.Emoji`, a `Crux.Structs.Reaction`, or a `String.t()` to its discord identifier format.

    > This is automatically done if using a appropriate rest function.

  ## Examples

    ```elixir
  # A custom emoji
  iex> %Crux.Structs.Emoji{animated: false, id: 396521773216301056, name: "blobwavereverse"}
  ...> |> Crux.Structs.Emoji.to_identifier()
  "blobwavereverse:396521773216301056"

  # A custom animated emoji
  iex> %Crux.Structs.Emoji{animated: true, id: 396521774466203659, name: "ablobwavereverse"}
  ...> |> Crux.Structs.Emoji.to_identifier()
  "a:ablobwavereverse:396521774466203659"

  # A regular emoji
  iex> %Crux.Structs.Emoji{animated: false, id: nil, name: "👋"}
  ...> |> Crux.Structs.Emoji.to_identifier()
  "%F0%9F%91%8B"

  # A reaction struct
  iex> %Crux.Structs.Reaction{
  ...>   emoji: %Crux.Structs.Emoji{animated: false, id: 356830260626456586, name: "blobReach"}
  ...> }
  ...> |> Crux.Structs.Emoji.to_identifier()
  "blobReach:356830260626456586"

  # An already encoded identifier
  iex> "👀" |> URI.encode_www_form()
  ...> |> Crux.Structs.Emoji.to_identifier()
  "%F0%9F%91%80"

  # A custom emoji's identifier
  iex> "eyesRight:271412698267254784"
  ...> |> Crux.Structs.Emoji.to_identifier()
  "eyesRight:271412698267254784"

    ```
  """
  @spec to_identifier(emoji :: Crux.Structs.Emoji.t() | Crux.Structs.Reaction.t() | String.t()) ::
          String.t()
  def to_identifier(%Crux.Structs.Reaction{emoji: emoji}), do: to_identifier(emoji)
  def to_identifier(%__MODULE__{id: nil, name: name}), do: name |> URI.encode_www_form()
  def to_identifier(%__MODULE__{id: id, name: name, animated: true}), do: "a:#{name}:#{id}"
  def to_identifier(%__MODULE__{id: id, name: name}), do: "#{name}:#{id}"
  def to_identifier(identifier) when is_bitstring(identifier), do: identifier

  defimpl String.Chars, for: Crux.Structs.Emoji do
    def to_string(%Crux.Structs.Emoji{id: nil, name: name}), do: name

    def to_string(%Crux.Structs.Emoji{id: id, name: name, animated: true}),
      do: "<a:#{name}:#{id}>"

    def to_string(%Crux.Structs.Emoji{id: id, name: name}), do: "<:#{name}:#{id}>"
  end
end
