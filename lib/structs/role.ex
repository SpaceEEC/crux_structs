defmodule Crux.Structs.Role do
  @moduledoc """
    Represents a Discord [Role Object](https://discordapp.com/developers/docs/topics/permissions#role-object-role-structure).
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Permissions, Role, Snowflake, Util}
  require Util

  Util.modulesince("0.1.0")

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

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          color: integer(),
          hoist: boolean(),
          position: integer(),
          permissions: Permissions.raw(),
          managed: boolean(),
          mentionable: boolean(),
          guild_id: Snowflake.t()
        }

  @typedoc """
    All available types that can be resolved into a role id.
  """
  Util.typesince("0.2.1")
  @type id_resolvable() :: Role.t() | Snowflake.t() | String.t() | nil

  @typedoc """
    All available types that can be resolved into a role position.
  """
  Util.typesince("0.2.1")

  @type position_resolvable() ::
          Role.t()
          | %{role: id_resolvable(), position: integer()}
          | {id_resolvable(), integer()}
          | %{id: id_resolvable(), position: integer()}

  @doc """
    Resolves a `t:position_resolvable/0` into a role position.

  ## Examples

    ```elixir
    iex> {%Crux.Structs.Role{id: 373405430589816834}, 5}
    ...> |> Crux.Structs.Role.resolve_position()
    %{id: 373405430589816834, position: 5}

    iex> %Crux.Structs.Role{id: 373405430589816834, position: 5}
    ...> |> Crux.Structs.Role.resolve_position()
    %{id: 373405430589816834, position: 5}

    iex> %{id: 373405430589816834, position: 5}
    ...> |> Crux.Structs.Role.resolve_position()
    %{id: 373405430589816834, position: 5}

    iex> %{role: %Crux.Structs.Role{id: 373405430589816834}, position: 5}
    ...> |> Crux.Structs.Role.resolve_position()
    %{id: 373405430589816834, position: 5}

    iex> {373405430589816834, 5}
    ...> |> Crux.Structs.Role.resolve_position()
    %{id: 373405430589816834, position: 5}

    iex> {nil, 5}
    ...> |> Crux.Structs.Role.resolve_position()
    nil

    ```
  """
  Util.since("0.2.1")
  @spec resolve_position(position_resolvable()) :: %{id: Snowflake.t(), position: integer()} | nil
  def resolve_position(resolvable)

  def resolve_position(%Role{id: id, position: position}) do
    validate_position(%{id: id, position: position})
  end

  def resolve_position(%{role: resolvable, position: position}) do
    validate_position(%{id: Structs.resolve_id(resolvable, Role), position: position})
  end

  def resolve_position({resolvable, position}) do
    validate_position(%{id: Structs.resolve_id(resolvable, Role), position: position})
  end

  def resolve_position(%{id: resolvable, position: position}) do
    validate_position(%{id: Structs.resolve_id(resolvable, Role), position: position})
  end

  @spec validate_position(%{id: Snowflake.t(), position: integer()}) :: %{
          id: Snowflake.t(),
          position: integer()
        }
  @spec validate_position(%{id: nil, position: integer()}) :: nil
  defp validate_position(%{id: nil, position: _}), do: nil

  defp validate_position(%{id: _id, position: position} = entry)
       when is_integer(position) do
    entry
  end

  @doc """
    Creates a `t:Crux.Structs.Role.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    role =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)

    struct(__MODULE__, role)
  end

  @doc ~S"""
    Converts a `t:Crux.Structs.Role.t/0` into its discord mention format.

  ## Example

    ```elixir
  iex> %Crux.Structs.Role{id: 376146940762783746}
  ...> |> Crux.Structs.Role.to_mention()
  "<@&376146940762783746>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.Role.t()) :: String.t()
  Util.since("0.1.1")
  def to_mention(%__MODULE__{id: id}), do: "<@&#{id}>"

  defimpl String.Chars, for: Crux.Structs.Role do
    @spec to_string(Role.t()) :: String.t()
    def to_string(%Role{} = data), do: Role.to_mention(data)
  end
end
