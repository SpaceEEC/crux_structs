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
  alias Crux.Structs.{Channel, Guild, Member, Message, Role, Snowflake, Util, VoiceState}
  alias __MODULE__.SystemChannelFlags

  defstruct [
    :id,
    :name,
    :icon,
    :splash,
    :discovery_splash,
    :owner_id,
    :region,
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
    :approximate_presence_count
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          icon: String.t() | nil,
          splash: String.t() | nil,
          discovery_splash: String.t() | nil,
          owner_id: Snowflake.t(),
          region: String.t(),
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
          approximate_presence_count: pos_integer()
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
      |> Map.update(:emojis, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))
      |> Map.update(:features, %MapSet{}, &MapSet.new/1)
      |> Map.update(:system_channel_flags, nil, &SystemChannelFlags.new/1)
      # :voice_states
      # :members
      |> Map.update(:channels, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))

    # :presences

    guild =
      data
      |> Map.update(
        :roles,
        %{},
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
        %{},
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
        %{},
        &Map.new(&1, fn member ->
          member =
            member
            |> Map.put(:guild_id, data.id)
            |> Structs.create(Member)

          {member.user, member}
        end)
      )

    struct(__MODULE__, guild)
  end

  defimpl String.Chars, for: Crux.Structs.Guild do
    @spec to_string(Guild.t()) :: String.t()
    def to_string(%Guild{name: name}), do: name
  end
end
