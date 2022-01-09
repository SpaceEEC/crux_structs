defmodule Crux.Structs.Member do
  @moduledoc """
  Represents a Discord [Guild Member Object](https://discord.com/developers/docs/resources/guild#guild-member-object).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs.{Member, Permissions, Snowflake, User, Util}
  require Util

  defstruct [
    :user,
    :nick,
    :avatar,
    :roles,
    :joined_at,
    :premium_since,
    :deaf,
    :mute,
    :pending,
    :permissions,
    :communication_disabled_until,
    # Additional
    :guild_id
  ]

  @typedoc since: "0.2.1"
  @type t :: %__MODULE__{
          user: Snowflake.t(),
          nick: String.t() | nil,
          avatar: String.t() | nil,
          roles: MapSet.t(Snowflake.t()),
          joined_at: String.t(),
          premium_since: String.t() | nil,
          deaf: boolean() | nil,
          mute: boolean() | nil,
          pending: boolean() | nil,
          permissions: Permissions.t() | nil,
          communication_disabled_until: String.t() | nil,
          guild_id: Snowflake.t() | nil
        }

  @typedoc """
  All available types that can be resolved into a user id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: User.id_resolvable()

  @doc """
  Resolves the id of a `t:Crux.Structs.Member.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

  ```elixir
  iex> %Crux.Structs.Member{user: 218348062828003328}
  ...> |> Crux.Structs.Member.resolve_id()
  218348062828003328
  ```

  For more examples see `Crux.Structs.User.resolve_id/1`.
  """
  @doc since: "0.2.1"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  defdelegate resolve_id(resolvable), to: User

  @doc """
  Creates a `t:Crux.Structs.Member.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    member =
      data
      |> Util.atomify()
      |> Map.update!(:user, Util.map_to_id())
      |> Map.update!(:roles, &MapSet.new(&1, fn role_id -> Snowflake.to_snowflake(role_id) end))
      |> Map.update(:permissions, nil, &Permissions.resolve/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)

    struct(__MODULE__, member)
  end

  @doc ~S"""
  Converts a `t:Crux.Structs.Member.t/0` into its discord mention format.

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
  @doc since: "0.1.1"
  @spec to_mention(user :: Crux.Structs.Member.t()) :: String.t()
  def to_mention(%__MODULE__{user: id, nick: nil}), do: "<@#{id}>"
  def to_mention(%__MODULE__{user: id}), do: "<@!#{id}>"

  defimpl String.Chars, for: Crux.Structs.Member do
    @spec to_string(Member.t()) :: String.t()
    def to_string(%Member{} = data), do: Member.to_mention(data)
  end
end
