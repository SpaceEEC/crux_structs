defmodule Crux.Structs.Emoji do
  @moduledoc """
  Represents a Discord [Emoji Object](https://discordapp.com/developers/docs/resources/emoji#emoji-object-emoji-structure).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Emoji, Reaction, Snowflake, Util}
  require Util
  require Snowflake

  Util.modulesince("0.1.0")

  defstruct(
    animated: nil,
    id: nil,
    name: nil,
    roles: nil,
    user: nil,
    require_colons: nil,
    managed: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          animated: boolean() | nil,
          id: Snowflake.t() | nil,
          name: String.t(),
          roles: MapSet.t(Snowflake.t()),
          user: Snowflake.t() | nil,
          require_colons: boolean() | nil,
          managed: boolean() | nil
        }

  @typedoc """
    All available types that can be resolved into an emoji id.
  """
  Util.typesince("0.2.1")
  @type id_resolvable() :: Reaction.t() | Emoji.t() | Snowflake.t() | String.t()

  @doc """
    Resolves the id of a `t:Crux.Structs.Emoji.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

    ```elixir
    iex> %Crux.Structs.Emoji{id: 618731477143912448}
    ...> |> Crux.Structs.Emoji.resolve_id()
    618731477143912448

    iex> %Crux.Structs.Reaction{emoji: %Crux.Structs.Emoji{id: 618731477143912448}}
    ...> |> Crux.Structs.Emoji.resolve_id()
    618731477143912448

    iex> 618731477143912448
    ...> |> Crux.Structs.Emoji.resolve_id()
    618731477143912448

    iex> "618731477143912448"
    ...> |> Crux.Structs.Emoji.resolve_id()
    618731477143912448

    ```
  """
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  Util.since("0.2.1")

  def resolve_id(%Reaction{emoji: emoji}) do
    resolve_id(emoji)
  end

  def resolve_id(%Emoji{id: id}) do
    resolve_id(id)
  end

  def resolve_id(data), do: Crux.Structs.resolve_id(data)

  @doc """
    Creates a `t:Crux.Structs.Emoji.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    emoji =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(
        :roles,
        MapSet.new(),
        &MapSet.new(&1, fn role -> Snowflake.to_snowflake(role) end)
      )
      |> Map.update(:user, nil, Util.map_to_id())

    struct(__MODULE__, emoji)
  end

  @doc ~S"""
    Converts an `t:Crux.Structs.Emoji.t/0`, a `t:Crux.Structs.Reaction.t/0`, or a `t:String.t/0` to its discord identifier format.

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
  iex> "👀"
  ...> |> URI.encode_www_form()
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
  Util.since("0.1.1")
  def to_identifier(%Crux.Structs.Reaction{emoji: emoji}), do: to_identifier(emoji)
  def to_identifier(%__MODULE__{id: nil, name: name}), do: URI.encode_www_form(name)
  def to_identifier(%__MODULE__{id: id, name: name, animated: true}), do: "a:#{name}:#{id}"
  def to_identifier(%__MODULE__{id: id, name: name}), do: "#{name}:#{id}"
  def to_identifier(identifier) when is_bitstring(identifier), do: identifier

  defimpl String.Chars, for: Crux.Structs.Emoji do
    @spec to_string(Emoji.t()) :: String.t()
    def to_string(%Emoji{id: nil, name: name}), do: name

    def to_string(%Emoji{id: id, name: name, animated: true}),
      do: "<a:#{name}:#{id}>"

    def to_string(%Emoji{id: id, name: name}), do: "<:#{name}:#{id}>"
  end
end
