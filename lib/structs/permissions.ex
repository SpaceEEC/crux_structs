defmodule Crux.Structs.Permissions do
  @moduledoc """
    Custom non discord api struct to help with working with permissions.

    For more informations see [Discord Docs](https://discordapp.com/developers/docs/topics/permissions).
  """

  alias Crux.Structs
  alias Crux.Structs.Util

  use Bitwise

  permissions = %{
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
    view_guild_insights: 1 <<< 19,
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

  use Crux.Structs.BitField, permissions

  require Util

  Util.modulesince("0.1.3")

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
          | :view_guild_insights
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
        raise ArgumentError, """
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
