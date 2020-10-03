defmodule Crux.Structs.Overwrite do
  @moduledoc """
    Represents a Discord [Overwrite Object](https://discord.com/developers/docs/resources/channel#overwrite-object).
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Overwrite, Permissions, Role, Snowflake, User, Util}

  defstruct [
    :id,
    :type,
    :allow,
    :deny
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          type: 0..1,
          allow: Permissions.t(),
          deny: Permissions.t()
        }

  @typedoc """
  The target of an overwrite.
  - `0` role
  - `1` member
  """
  @typedoc since: "0.3.0"
  @type target_type :: 0..1
  @target_role 0
  @target_member 1

  @typedoc """
    All available types that can be resolved into a target for a permission overwrite
  """
  @typedoc since: "0.2.1"
  @type target_resolvable() :: Overwrite.t() | Role.t() | User.id_resolvable()

  @doc """
    Resolves a `t:target_resolvable/0` into an overwrite target.

  > Note that an id or string of it returns `:unknown` as type.

  ## Examples

    ```elixir
    iex> %Crux.Structs.Overwrite{type: #{@target_member}, id: 218348062828003328}
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {#{@target_member}, 218348062828003328}

    iex> %Crux.Structs.Role{id: 376146940762783746}
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {#{@target_role}, 376146940762783746}

    iex> %Crux.Structs.User{id: 218348062828003328}
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {#{@target_member}, 218348062828003328}

    iex> %Crux.Structs.Member{user: 218348062828003328}
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {#{@target_member}, 218348062828003328}

    iex> %Crux.Structs.Message{author: %Crux.Structs.User{id: 218348062828003328}}
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {#{@target_member}, 218348062828003328}

    iex> %Crux.Structs.VoiceState{user_id: 218348062828003328}
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {#{@target_member}, 218348062828003328}

    iex> 218348062828003328
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {:unknown, 218348062828003328}

    iex> "218348062828003328"
    ...> |> Crux.Structs.Overwrite.resolve_target()
    {:unknown, 218348062828003328}

    iex> nil
    ...> |> Crux.Structs.Overwrite.resolve_target()
    nil

    ```
  """
  @doc since: "0.2.1"
  @spec resolve_target(target_resolvable()) :: {target_type() | :unknown, Snowflake.t()}
  def resolve_target(%Overwrite{id: id, type: type}), do: {type, id}
  def resolve_target(%Role{id: id}), do: {@target_role, id}

  def resolve_target(resolvable) do
    case Structs.resolve_id(resolvable, User) do
      nil -> nil
      id when is_map(resolvable) -> {@target_member, id}
      id -> {:unknown, id}
    end
  end

  @doc """
    Creates a `t:Crux.Structs.Overwrite.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    overwrite =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update!(:allow, &Permissions.new/1)
      |> Map.update!(:deny, &Permissions.new/1)

    struct(__MODULE__, overwrite)
  end
end
