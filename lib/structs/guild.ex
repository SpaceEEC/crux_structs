defmodule Crux.Structs.Guild do
  @moduledoc """
  Represents a Discord [Guild Object](https://discord.com/developers/docs/resources/guild#guild-object).

  Differences opposed to the Discord API Object:
  - `:channels` is a `MapSet` of channel ids
  - `:emojis` is a `MapSet` of emoji ids
  - `:presences` does not exists at all
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs

  alias Crux.Structs.{
    Channel,
    Guild,
    GuildScheduledEvent,
    Member,
    Message,
    Role,
    Snowflake,
    StageInstance,
    Sticker,
    Util,
    VoiceState
  }

  alias Guild.SystemChannelFlags

  defstruct [
    :id,
    :name,
    :icon,
    :splash,
    :discovery_splash,
    :owner_id,
    :afk_channel_id,
    :afk_timeout,
    :widget_enabled,
    :widget_channel_id,
    :verification_level,
    :default_message_notifications,
    :explicit_content_filter,
    :roles,
    :emojis,
    :features,
    :mfa_level,
    :application_id,
    :system_channel_id,
    :system_channel_flags,
    :rules_channel_id,
    :joined_at,
    :large,
    :unavailable,
    :member_count,
    :voice_states,
    :members,
    :channels,
    :threads,
    # :presences,
    :max_presences,
    :max_members,
    :vanity_url_code,
    :description,
    :banner,
    :premium_tier,
    :premium_subscription_count,
    :preferred_locale,
    :public_updates_channel_id,
    :max_video_channel_users,
    :approximate_member_count,
    :approximate_presence_count,
    :welcome_screen,
    :nsfw_level,
    :stage_instances,
    :stickers,
    :guild_scheduled_events,
    :premium_progress_bar_enabled
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          icon: String.t() | nil,
          splash: String.t() | nil,
          discovery_splash: String.t() | nil,
          owner_id: Snowflake.t(),
          afk_channel_id: Snowflake.t(),
          afk_timeout: non_neg_integer(),
          widget_enabled: boolean() | nil,
          widget_channel_id: Snowflake.t() | nil,
          verification_level: 0..4,
          default_message_notifications: 0..1,
          explicit_content_filter: 0..2,
          roles: %{optional(Snowflake.t()) => Role.t()},
          emojis: MapSet.t(Snowflake.t()),
          features: MapSet.t(String.t()),
          mfa_level: 0..1,
          application_id: Snowflake.t() | nil,
          system_channel_id: Snowflake.t() | nil,
          system_channel_flags: Crux.Structs.Guild.SystemChannelFlags.t(),
          rules_channel_id: Snowflake.t(),
          joined_at: String.t(),
          large: boolean(),
          unavailable: boolean(),
          member_count: pos_integer(),
          voice_states: %{optional(Snowflake.t()) => VoiceState.t()},
          members: %{required(Snowflake.t()) => Member.t()},
          channels: MapSet.t(Snowflake.t()),
          threads: %{required(Snowflake.t()) => Channel.t()},
          # presences: %{required(Snowflake.t()) => Presence.t()},
          max_presences: pos_integer() | nil,
          max_members: pos_integer(),
          vanity_url_code: String.t() | nil,
          description: String.t() | nil,
          banner: String.t() | nil,
          premium_tier: 0..3,
          premium_subscription_count: non_neg_integer(),
          preferred_locale: String.t(),
          public_updates_channel_id: Snowflake.t() | nil,
          max_video_channel_users: non_neg_integer(),
          approximate_member_count: pos_integer(),
          approximate_presence_count: pos_integer(),
          welcome_screen: welcome_screen() | nil,
          nsfw_level: 0..3,
          stage_instances: %{required(Snowflake.t()) => StageInstance.t()},
          stickers: %{required(Snowflake.t()) => Sticker.t()},
          guild_scheduled_events: %{required(Snowflake.t()) => GuildScheduledEvent.t()},
          premium_progress_bar_enabled: boolean()
        }

  @type welcome_screen :: %{
          description: String.t(),
          welcome_channels: %{
            required(Snowflake.t()) => %{
              channel_id: Snowflake.t(),
              description: String.t(),
              emoji_id: Snowflake.t() | nil,
              emoji_name: String.t() | nil
            }
          }
        }

  @typedoc """
  All available types that can be resolved into a guild id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Guild.t() | Channel.t() | Message.t() | Snowflake.t()

  @doc """
  Resolves the id of a `t:Crux.Structs.Guild.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.


  ```elixir
  iex> %Crux.Structs.Guild{id: 516569101267894284}
  ...> |> Crux.Structs.Guild.resolve_id()
  516569101267894284

  iex> %Crux.Structs.Channel{guild_id: 516569101267894284}
  ...> |> Crux.Structs.Guild.resolve_id()
  516569101267894284

  iex> %Crux.Structs.Message{guild_id: 516569101267894284}
  ...> |> Crux.Structs.Guild.resolve_id()
  516569101267894284

  iex> 516569101267894284
  ...> |> Crux.Structs.Guild.resolve_id()
  516569101267894284

  iex> "516569101267894284"
  ...> |> Crux.Structs.Guild.resolve_id()
  516569101267894284

  # DMs
  iex> %Crux.Structs.Channel{guild_id: nil}
  ...> |> Crux.Structs.Guild.resolve_id()
  nil

  iex> %Crux.Structs.Message{guild_id: nil}
  ...> |> Crux.Structs.Guild.resolve_id()
  nil

  ```
  """
  @doc since: "0.2.1"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  def resolve_id(%Guild{id: id}) do
    resolve_id(id)
  end

  def resolve_id(%Channel{guild_id: guild_id}) do
    resolve_id(guild_id)
  end

  def resolve_id(%Message{guild_id: guild_id}) do
    resolve_id(guild_id)
  end

  def resolve_id(resolvable), do: Structs.resolve_id(resolvable)

  @doc """
  Creates a `t:Crux.Structs.Guild.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:owner_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:afk_channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:widget_channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:application_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:system_channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:public_updates_channel_id, nil, &Snowflake.to_snowflake/1)
      # :roles
      |> Map.update(:emojis, nil, &MapSet.new(&1, Util.map_to_id()))
      |> Map.update(:features, nil, &MapSet.new/1)
      |> Map.update(:system_channel_flags, nil, &SystemChannelFlags.resolve/1)
      # :voice_states
      # :members
      |> Map.update(:channels, nil, &MapSet.new(&1, Util.map_to_id()))
      |> Map.update(:welcome_screen, nil, &create_welcome_screen/1)

    # :threads
    # :presences
    # :stage_instances
    # :stickers
    # :guild_scheduled_events

    guild =
      data
      |> Map.update(
        :roles,
        nil,
        &Map.new(&1, fn role ->
          role =
            role
            |> Map.put(:guild_id, data.id)
            |> Structs.create(Role)

          {role.id, role}
        end)
      )
      |> Map.update(
        :voice_states,
        nil,
        &Map.new(&1, fn voice_state ->
          voice_state =
            voice_state
            |> Map.put(:guild_id, data.id)
            |> Structs.create(VoiceState)

          {voice_state.user_id, voice_state}
        end)
      )
      |> Map.update(
        :members,
        nil,
        &Map.new(&1, fn member ->
          member =
            member
            |> Map.put(:guild_id, data.id)
            |> Structs.create(Member)

          {member.user, member}
        end)
      )
      |> Map.update(
        :threads,
        nil,
        &Map.new(&1, fn thread ->
          thread =
            thread
            |> Map.put(:guild_id, data.id)
            |> Structs.create(Channel)

          {thread.id, thread}
        end)
      )
      |> Map.update(
        :stage_instances,
        nil,
        &Map.new(&1, fn stage_instance ->
          stage_instance =
            stage_instance
            |> Map.put(:guild_id, data.id)
            |> Structs.create(StageInstance)

          {stage_instance.id, stage_instance}
        end)
      )
      |> Map.update(
        :stickers,
        nil,
        &Map.new(&1, fn sticker ->
          sticker =
            sticker
            |> Map.put(:guild_id, data.id)
            |> Structs.create(Sticker)

          {sticker.id, sticker}
        end)
      )
      |> Map.update(
        :guild_scheduled_events,
        nil,
        &Map.new(&1, fn guild_scheduled_event ->
          guild_scheduled_event =
            guild_scheduled_event
            |> Map.put(:guild_id, data.id)
            |> Structs.create(GuildScheduledEvent)

          {guild_scheduled_event.id, guild_scheduled_event}
        end)
      )

    struct(__MODULE__, guild)
  end

  defp create_welcome_screen(nil), do: nil

  defp create_welcome_screen(welcome_screen) do
    Map.update!(
      welcome_screen,
      :welcome_channels,
      &Map.new(&1, fn welcome_channel ->
        welcome_channel =
          welcome_channel
          |> Map.update!(:channel_id, fn
            channel_id -> Snowflake.to_snowflake(channel_id)
          end)
          |> Map.update!(:emoji_id, fn
            nil -> nil
            id -> Snowflake.to_snowflake(id)
          end)

        {welcome_channel.channel_id, welcome_channel}
      end)
    )
  end

  defimpl String.Chars, for: Crux.Structs.Guild do
    @spec to_string(Guild.t()) :: String.t()
    def to_string(%Guild{name: name}), do: name
  end
end
