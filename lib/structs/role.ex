defmodule Crux.Structs.Role do
  @moduledoc """
  Represents a Discord [Role Object](https://discord.com/developers/docs/topics/permissions#role-object).
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Permissions, Role, Snowflake, Util}

  defstruct [
    :id,
    :name,
    :color,
    :hoist,
    :icon,
    :unicode_emoji,
    :position,
    :permissions,
    :managed,
    :mentionable,
    :tags,
    # Additional
    :guild_id
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          color: integer(),
          hoist: boolean(),
          icon: String.t() | nil,
          unicode_emoji: String.t() | nil,
          position: integer(),
          permissions: Permissions.t(),
          managed: boolean(),
          mentionable: boolean(),
          guild_id: Snowflake.t(),
          tags: tags()
        }

  @typedoc since: "0.3.0"
  @type tags :: %{
          optional(:bot_id) => Snowflake.t(),
          optional(:integration_id) => Snowflake.t(),
          optional(:premium_subscriber) => nil
        }

  @typedoc """
  All available types that can be resolved into a role id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Role.t() | Snowflake.t() | String.t() | nil

  @typedoc """
  All available types that can be resolved into a role position.
  """
  @typedoc since: "0.2.1"
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
  @doc since: "0.2.1"
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

  @doc since: "0.2.1"
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
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    role =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:permissions, nil, &Permissions.resolve/1)
      |> Map.update(:tags, nil, &create_tags/1)

    struct(__MODULE__, role)
  end

  defp create_tags(nil), do: nil

  defp create_tags(tags) do
    tags =
      if Map.has_key?(tags, :bot_id) do
        Map.update!(tags, :bot_id, &Snowflake.to_snowflake/1)
      else
        tags
      end

    tags =
      if Map.has_key?(tags, :integration_id) do
        Map.update!(tags, :integration_id, &Snowflake.to_snowflake/1)
      else
        tags
      end

    tags
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
  @doc since: "0.1.1"
  @spec to_mention(user :: Crux.Structs.Role.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<@&#{id}>"

  defimpl String.Chars, for: Crux.Structs.Role do
    @spec to_string(Role.t()) :: String.t()
    def to_string(%Role{} = data), do: Role.to_mention(data)
  end
end
