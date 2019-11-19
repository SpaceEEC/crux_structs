defmodule Crux.Structs.Permissions do
  @moduledoc """
    Custom non discord api struct to help with working with permissions.

    For more informations see [Discord Docs](https://discordapp.com/developers/docs/topics/permissions).
  """
  use Bitwise

  alias Crux.Structs
  alias Crux.Structs.Util
  require Util

  Util.modulesince("0.1.3")

  @permissions %{
    create_instant_invite: 1 <<< 0,
    kick_members: 1 <<< 1,
    ban_members: 1 <<< 2,
    administrator: 1 <<< 3,
    manage_channels: 1 <<< 4,
    manage_guild: 1 <<< 5,
    add_reactions: 1 <<< 6,
    view_audit_log: 1 <<< 7,
    priority_speaker: 1 <<< 8,
    stream: 1 <<< 9,
    view_channel: 1 <<< 10,
    send_messages: 1 <<< 11,
    send_tts_message: 1 <<< 12,
    manage_messages: 1 <<< 13,
    embed_links: 1 <<< 14,
    attach_files: 1 <<< 15,
    read_message_history: 1 <<< 16,
    mention_everyone: 1 <<< 17,
    use_external_emojis: 1 <<< 18,
    # 19
    connect: 1 <<< 20,
    speak: 1 <<< 21,
    mute_members: 1 <<< 22,
    deafen_members: 1 <<< 23,
    move_members: 1 <<< 24,
    use_vad: 1 <<< 25,
    change_nickname: 1 <<< 26,
    manage_nicknames: 1 <<< 27,
    manage_roles: 1 <<< 28,
    manage_webhooks: 1 <<< 29,
    manage_emojis: 1 <<< 30
  }
  @doc """
    Returns a map of all permissions.
  """
  @spec flags() :: %{name() => non_neg_integer()}
  Util.since("0.2.0")
  def flags, do: @permissions

  @names Map.keys(@permissions)
  @doc """
  Returns a list of all permission keys.
  """
  @spec names() :: [name()]
  Util.since("0.2.0")
  def names, do: @names

  @all @permissions |> Map.values() |> Enum.reduce(&|||/2)
  @doc """
    Returns the integer value of all permissions summed up.
  """
  @spec all :: pos_integer()
  Util.since("0.2.0")
  def all, do: @all

  @typedoc """
    Union type of all valid permission name atoms.
  """
  Util.typesince("0.2.0")

  @type name ::
          :create_instant_invite
          | :kick_members
          | :ban_members
          | :administrator
          | :manage_channels
          | :manage_guild
          | :add_reactions
          | :view_audit_log
          | :priority_speaker
          | :stream
          | :view_channel
          | :send_messages
          | :send_tts_message
          | :manage_messages
          | :embed_links
          | :attach_files
          | :read_message_histroy
          | :mention_everyone
          | :use_external_emojis
          | :connect
          | :speak
          | :mute_members
          | :deafen_members
          | :move_members
          | :use_vad
          | :change_nickname
          | :manage_nicknames
          | :manage_roles
          | :manage_webhooks
          | :manage_emojis

  defstruct(bitfield: 0)

  @typedoc """
    All valid types which can be directly resolved into a permissions bitfield.
  """
  Util.typesince("0.2.0")
  @type resolvable :: t() | non_neg_integer() | name() | [resolvable()]

  @typedoc """
    Represents a `t:Crux.Structs.Permissions.t/0`.

    * `:bitfield`: The raw bitfield of permission flags.
  """
  Util.typesince("0.1.3")

  @type t :: %__MODULE__{
          bitfield: non_neg_integer()
        }

  @doc """
    Creates a new `t:Crux.Structs.Permissions.t/0` from a valid `t:resolvable/0`.
  """
  @spec new(permissions :: resolvable()) :: t()
  Util.since("0.1.3")
  def new(permissions \\ 0), do: %__MODULE__{bitfield: resolve(permissions)}

  @doc ~S"""
    Resolves a `t:resolvable/0` into a bitfield representing the set permissions.

  ## Examples
    ```elixir
  # A single bitflag
  iex> 0x8
  ...> |> Crux.Structs.Permissions.resolve()
  0x8

  # A single name
  iex> :administrator
  ...> |> Crux.Structs.Permissions.resolve()
  0x8

  # A list of bitflags
  iex> [0x8, 0x4]
  ...> |> Crux.Structs.Permissions.resolve()
  0xC

  # A list of names
  iex> [:administrator, :ban_members]
  ...> |> Crux.Structs.Permissions.resolve()
  0xC

  # A mixture of both
  iex> [:manage_roles, 0x400, 0x800, :add_reactions]
  ...> |> Crux.Structs.Permissions.resolve()
  0x10000C40

  # An empty list
  iex> []
  ...> |> Crux.Structs.Permissions.resolve()
  0x0

    ```
  """
  @spec resolve(permissions :: resolvable()) :: non_neg_integer()
  Util.since("0.1.3")
  def resolve(permissions)

  def resolve(%__MODULE__{bitfield: bitfield}), do: bitfield

  def resolve(permissions) when is_integer(permissions) and permissions >= 0 do
    Enum.reduce(@permissions, 0, fn {_name, value}, acc ->
      if (permissions &&& value) == value, do: acc ||| value, else: acc
    end)
  end

  def resolve(permissions) when permissions in @names do
    Map.get(@permissions, permissions)
  end

  def resolve(permissions) when is_list(permissions) do
    permissions
    |> Enum.map(&resolve/1)
    |> Enum.reduce(0, &|||/2)
  end

  def resolve(permissions) do
    raise """
    Expected a name atom, a non negative integer, or a list of them.

    Received:
    #{inspect(permissions)}
    """
  end

  @doc ~S"""
    Serializes permissions into a map keyed by `t:name/0` with a boolean indicating whether the permission is set.
  """
  @spec to_map(permissions :: resolvable()) :: %{name() => boolean()}
  Util.since("0.1.3")

  def to_map(permissions) do
    permissions = resolve(permissions)

    Map.new(@names, &{&1, has(permissions, &1)})
  end

  @doc ~S"""
    Serializes permissions into a list of set `t:name/0`s.

  ## Examples
    ```elixir
  iex> 0x30
  ...> |> Crux.Structs.Permissions.to_list()
  [:manage_guild, :manage_channels]

    ```
  """
  @spec to_list(permissions :: resolvable()) :: [name()]
  Util.since("0.1.3")

  def to_list(permissions) do
    permissions = resolve(permissions)

    Enum.reduce(@permissions, [], fn {name, val}, acc ->
      if has(permissions, val), do: [name | acc], else: acc
    end)
  end

  @doc ~S"""
    Adds permissions to the base permissions.

  ## Examples
    ```elixir
  iex> :administrator
  ...> |> Crux.Structs.Permissions.add(:manage_guild)
  %Crux.Structs.Permissions{bitfield: 0x28}

    ```
  """
  @spec add(base :: resolvable(), to_add :: resolvable()) :: t()
  Util.since("0.1.3")

  def add(base, to_add) do
    to_add = resolve(to_add)

    base
    |> resolve()
    |> bor(to_add)
    |> new()
  end

  @doc ~S"""
    Removes permissions from the base permissions

  ## Examples
    ```elixir
  iex> [0x8, 0x10, 0x20]
  ...> |> Crux.Structs.Permissions.remove([0x10, 0x20])
  %Crux.Structs.Permissions{bitfield: 0x8}

    ```
  """
  @spec remove(base :: resolvable(), to_remove :: resolvable()) :: t()
  Util.since("0.1.3")

  def remove(base, to_remove) do
    to_remove = to_remove |> resolve() |> bnot()

    base
    |> resolve()
    |> band(to_remove)
    |> new()
  end

  @doc ~S"""
    Check whether the second permissions are all present in the first.

  ## Examples
    ```elixir
  # Administrator won't grant any other permissions
  iex> Crux.Structs.Permissions.has(0x8, Crux.Structs.Permissions.all())
  false

  # Resolving a list of `permissions_name`s
  iex> Crux.Structs.Permissions.has([:send_messages, :view_channel, :read_message_history], [:send_messages, :view_channel])
  true

  # Resolving different types of `permissions`s
  iex> Crux.Structs.Permissions.has(:administrator, 0x8)
  true

  # In different order
  iex> Crux.Structs.Permissions.has(0x8, :administrator)
  true

    ```
  """
  @spec has(
          have :: resolvable(),
          want :: resolvable()
        ) :: boolean()
  Util.since("0.1.3")

  def has(have, want) do
    have = resolve(have)
    want = resolve(want)

    (have &&& want) == want
  end

  @doc ~S"""
    Similar to `has/2` but returns a `t:Crux.Structs.Permissions.t/0` of the missing permissions.

  ## Examples
    ```elixir
  iex> Crux.Structs.Permissions.missing([:send_messages, :view_channel], [:send_messages, :view_channel, :embed_links])
  %Crux.Structs.Permissions{bitfield: 0x4000}

  # Administrator won't implicilty grant other permissions
  iex> Crux.Structs.Permissions.missing([:administrator], [:send_messages])
  %Crux.Structs.Permissions{bitfield: 0x800}

  # Everything set
  iex> Crux.Structs.Permissions.missing([:kick_members, :ban_members, :view_audit_log], [:kick_members, :ban_members])
  %Crux.Structs.Permissions{bitfield: 0}

  # No permissions
  iex> Crux.Structs.Permissions.missing([:send_messages, :view_channel], [])
  %Crux.Structs.Permissions{bitfield: 0}

    ```
  """
  @spec missing(resolvable(), resolvable()) :: t()
  Util.since("0.2.0")

  def missing(have, want) do
    have = resolve(have)
    want = resolve(want)

    want
    |> band(~~~have)
    |> new()
  end

  @doc """
    Resolves permissions for a user in a guild, optionally including channel permission overwrites.

  > Raises when the member is not cached.

  > The guild-wide administrator flag or being owner implicitly grants all permissions, see `explicit/3`.
  """
  @spec implicit(
          member :: Structs.Member.t() | Structs.User.t() | Structs.Snowflake.t(),
          guild :: Structs.Guild.t(),
          channel :: Structs.Channel.t() | nil
        ) :: t()
  Util.since("0.2.0")
  def implicit(member, guild, channel \\ nil)

  def implicit(%Structs.User{id: user_id}, guild, channel), do: implicit(user_id, guild, channel)

  def implicit(%Structs.Member{user: user_id}, guild, channel),
    do: implicit(user_id, guild, channel)

  def implicit(user_id, %Structs.Guild{owner_id: user_id}, _), do: new(@all)

  def implicit(user_id, guild, channel) do
    permissions = explicit(user_id, guild)

    cond do
      has(permissions, :administrator) ->
        new(@all)

      channel ->
        explicit(user_id, guild, channel)

      true ->
        permissions
    end
  end

  @doc """
    Resolves permissions for a user in a guild, optionally including channel permission overwrites.

  > Raises when the member is not cached.

  > The administrator flag or being owner implicitly does not grant permissions, see `implicit/3`.
  """
  @spec explicit(
          member :: Structs.Member.t() | Structs.User.t() | Structs.Snowflake.t(),
          guild :: Structs.Guild.t(),
          channel :: Structs.Channel.t() | nil
        ) :: t()
  Util.since("0.2.0")

  def explicit(member, guild, channel \\ nil)

  def explicit(%Structs.Member{user: user_id}, guild, channel),
    do: explicit(user_id, guild, channel)

  def explicit(%Structs.User{id: user_id}, guild, channel), do: explicit(user_id, guild, channel)

  # -> compute_base_permissions from
  # https://discordapp.com/developers/docs/topics/permissions#permission-overwrites
  def explicit(user_id, %Structs.Guild{id: guild_id, members: members, roles: roles}, nil) do
    member =
      Map.get(members, user_id) ||
        raise """
          There is no member with the ID "#{inspect(user_id)}" in the cache of the guild.
          The member is uncached or not in the guild.
        """

    permissions =
      roles
      |> Map.get(guild_id)
      |> Map.get(:permissions)

    member_roles =
      member.roles
      |> MapSet.put(guild_id)
      |> MapSet.to_list()

    roles
    |> Map.take(member_roles)
    |> Enum.map(fn {_id, %{permissions: permissions}} -> permissions end)
    |> List.insert_at(0, permissions)
    |> new()
  end

  # -> compute_permissions and compute_overwrites from
  # https://discordapp.com/developers/docs/topics/permissions#permission-overwrites
  def explicit(
        user_id,
        %Structs.Guild{id: guild_id, members: members} = guild,
        %Structs.Channel{permission_overwrites: overwrites}
      ) do
    %{bitfield: permissions} = explicit(user_id, guild)

    # apply @everyone overwrite
    base_permissions =
      overwrites
      |> Map.get(guild_id)
      |> apply_overwrite(permissions)

    role_ids =
      members
      |> Map.get(user_id)
      |> Map.get(:roles)
      |> MapSet.to_list()

    # apply all other overwrites
    role_permissions =
      overwrites
      |> Map.take(role_ids)
      |> Map.values()
      # reduce all relevant overwrites into a single dummy one
      |> Enum.reduce(%{allow: 0, deny: 0}, &acc_overwrite/2)
      # apply it to the base permissions
      |> apply_overwrite(base_permissions)

    # apply user overwrite
    overwrites
    |> Map.get(user_id)
    |> apply_overwrite(role_permissions)
    |> new()
  end

  defp acc_overwrite(nil, acc), do: acc

  defp acc_overwrite(%{allow: cur_allow, deny: cur_deny}, %{allow: allow, deny: deny}) do
    %{allow: cur_allow ||| allow, deny: cur_deny ||| deny}
  end

  defp apply_overwrite(nil, permissions), do: permissions

  defp apply_overwrite(%{allow: allow, deny: deny}, permissions) do
    permissions
    |> band(~~~deny)
    |> bor(allow)
  end
end
