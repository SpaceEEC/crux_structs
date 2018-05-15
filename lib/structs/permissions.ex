defmodule Crux.Structs.Permissions do
  @moduledoc """
    Custom non discord api struct to help with working with permissions.
  """
  use Bitwise

  alias Crux.Structs

  @permissions %{
    create_instant_invite: 1 <<< 0,
    kick_members: 1 <<< 1,
    ban_members: 1 <<< 2,
    administrator: 1 <<< 3,
    manage_channels: 1 <<< 4,
    manage_guild: 1 <<< 5,
    add_reactions: 1 <<< 6,
    view_audit_log: 1 <<< 7,
    # 8
    # 9 
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
  @permission_names @permissions |> Map.keys()
  @permission_all @permissions |> Map.values() |> Enum.reduce(&|||/2)

  @typedoc """
    Union type of all valid single permission atoms
  """
  @type permission_name ::
          :create_instant_invite
          | :kick_members
          | :ban_members
          | :administrator
          | :manage_channels
          | :manage_guild
          | :add_reactions
          | :view_audit_log
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

  @type t :: %__MODULE__{
          bitfield: non_neg_integer()
        }

  @typedoc """
    All valid types which can be directly resolved into a permissions bitfield.
  """
  @type permissions :: t() | [permission_name()] | non_neg_integer() | permission_name()

  @doc ~S"""
    Resolves a `t:permissions/0` into a bitfield representing the set permissions.

  ## Examples
    ```elixir
  # A single bitflag
  iex> 0x8
  ...> |> Crux.Structs.Permissions.resolve()
  0x8

  # A single permissions constant
  iex> :administrator
  ...> |> Crux.Structs.Permissions.resolve()
  0x8

  # A list of bitflags
  iex> [0x8, 0x4]
  ...> |> Crux.Structs.Permissions.resolve()
  0xC

  # A list of permissions constants
  iex> [:administrator, :ban_members]
  ...> |> Crux.Structs.Permissions.resolve()
  0xC

  iex> [:manage_roles, 0x400, 0x800, :add_reactions]
  ...> |> Crux.Structs.Permissions.resolve()
  0x10000C40

  ```
  """
  @spec resolve(permissions :: permissions()) :: non_neg_integer()
  def resolve(permissions)

  def resolve(%__MODULE__{bitfield: bitfield}), do: bitfield

  def resolve(permissions) when is_integer(permissions) and permissions >= 0 do
    Enum.reduce(@permissions, 0, fn {_name, value}, acc ->
      if (permissions &&& value) == value, do: acc ||| value, else: acc
    end)
  end

  def resolve(permissions) when permissions in @permission_names do
    Map.get(@permissions, permissions)
  end

  def resolve(permissions) when is_list(permissions) do
    Enum.map(permissions, &resolve/1)
    |> Enum.reduce(&|||/2)
  end

  def resolve(permissions) do
    raise """
    Expected a permission_name atom, a non negative integer, or a list of them.

    Received:
    #{inspect(permissions)}
    """
  end

  @doc """
    Creates a new `Crux.Structs.Permissions` struct from a valid `t:permissions/0`.
  """
  @spec new(permissions :: permissions()) :: t()
  def new(permissions), do: %__MODULE__{bitfield: resolve(permissions)}

  @doc """
    Serializes permissions into a map keyed by `t:permission_name/0` with a boolean indicating whether the permission_name is set.

  > The administrator flag implicitly grants all permissions.
  """
  @spec to_map(permissions :: permissions()) :: %{permission_name() => boolean()}
  def to_map(permissions) do
    permissions = resolve(permissions)

    Enum.reduce(@permissions, %{}, fn {name, val}, acc ->
      acc |> Map.put(name, has(permissions, val))
    end)
  end

  @doc ~S"""
    Serializes permissions into a list of set `t:permission_name/0`s.

  > The administrator flag implicitly grants all permissions.

  ## Examples
    ```elixir
  iex> 0x30
  ...> |> Crux.Structs.Permissions.to_list()
  [:manage_guild, :manage_channels]

    ```
  """
  @spec to_list(permissions :: permissions()) :: [permission_name()]
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
  @spec add(base :: permissions(), to_add :: permissions()) :: t()
  def add(base, to_add) do
    to_add = to_add |> resolve()

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
  @spec remove(base :: permissions(), to_remove :: permissions()) :: t()
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
  # All permissions except administrator set, but administrator overrides
  iex> Crux.Structs.Permissions.has(0x8, 0x7ff7fcf7)
  true

  iex> Crux.Structs.Permissions.has([:send_messages, :view_channel, :read_message_history], [:send_messages, :view_channel])
  true

  iex> Crux.Structs.Permissions.has(:administrator, 0x8)
  true

  iex> Crux.Structs.Permissions.has(0x8, :administrator)
  true

    ```
  """
  @spec has(permissions(), permissions()) :: boolean()
  def has(current, want) do
    current = resolve(current)

    if (current &&& 0x8) == 0x8 do
      true
    else
      want = resolve(want)

      (current &&& want) == want
    end
  end

  @doc """
    Resolves permissions for a user in a guild, optionally including channel permission overwrites.

  > Raises when the member is not cached.

  > The administrator flag or being owner implicitly grants all permissions.
  """
  @spec from(
          member :: Structs.Member.t() | Structs.User.t() | Crux.Rest.snowflake(),
          guild :: Structs.Guild.t(),
          channel :: Structs.Channel.t() | nil
        ) :: t()
  def from(member, guild, channel \\ nil)
  def from(%Structs.Member{user: user_id}, guild, channel), do: from(user_id, guild, channel)
  def from(%Structs.User{id: user_id}, guild, channel), do: from(user_id, guild, channel)

  def from(user_id, %Structs.Guild{owner_id: owner_id, members: members} = guild, nil) do
    cond do
      user_id == owner_id ->
        @permission_all
        |> new()

      Map.has_key?(members, user_id) ->
        _from(user_id, guild, nil)

      true ->
        raise """
          There is no member with the ID "#{user_id}" in the cache of the guild.
          The member is uncached or not in the guild.
        """
    end
  end

  def from(user_id, %Structs.Guild{} = guild, %Structs.Channel{} = channel) do
    permissions = from(user_id, guild)

    if has(permissions, :administrator) do
      @permission_all
      |> new()
    else
      _from(user_id, guild, channel, permissions)
    end
  end

  defp _from(user_id, %{id: guild_id, members: members, roles: roles}, nil) do
    member = Map.get(members, user_id)

    permissions =
      roles
      |> Map.get(guild_id)
      |> Map.get(:permissions)

    permissions =
      roles
      |> Map.take(member.roles)
      |> Map.values()
      |> Enum.reduce(permissions, fn %{permissions: permissions}, acc ->
        acc ||| permissions
      end)

    if has(permissions, :administrator) do
      @permission_all
    else
      permissions
    end
    |> new()
  end

  defp _from(
         user_id,
         %Structs.Guild{id: guild_id, members: members},
         %Structs.Channel{permission_overwrites: overwrites},
         permissions
       ) do
    permissions =
      overwrites
      |> Map.get(guild_id)
      |> apply_overwrite(permissions)

    role_ids = members |> Map.get(user_id) |> Map.get(:roles)

    permissions =
      overwrites
      |> Map.take(role_ids)
      |> Map.values()
      |> Enum.reduce(%{allow: 0, deny: 0}, &acc_overwrite/2)
      |> apply_overwrite(permissions)

    overwrites
    |> Map.get(user_id)
    |> apply_overwrite(permissions)
    |> new()
  end

  defp acc_overwrite(nil, acc), do: acc

  defp acc_overwrite(%{allow: allow, deny: deny}, %{} = acc) do
    acc
    |> Map.update!(:allow, &(&1 ||| allow))
    |> Map.update!(:deny, &(&1 ||| deny))
  end

  defp apply_overwrite(nil, permissions), do: permissions

  defp apply_overwrite(%{allow: allow, deny: deny}, permissions) do
    permissions = permissions &&& ~~~deny
    permissions = permissions ||| allow

    permissions
  end
end
