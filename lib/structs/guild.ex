defmodule Crux.Structs.Guild do
  @moduledoc """
  Represents a Discord [Guild Object](https://discordapp.com/developers/docs/resources/guild#guild-object-guild-structure).

  Differences opposed to the Discord API Object:
  - `:channels` is a `MapSet` of channel ids
  - `:emojis` is a `MapSet` of emoji ids
  - `:presences` does not exists at all
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Channel, Guild, Member, Message, Role, Snowflake, Util, VoiceState}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    afk_channel_id: nil,
    afk_timeout: nil,
    application_id: nil,
    banner: nil,
    channels: %MapSet{},
    default_message_notifications: nil,
    description: nil,
    discovery_splash: nil,
    embed_channel_id: nil,
    emojis: %MapSet{},
    explicit_content_filter: nil,
    features: %MapSet{},
    icon: nil,
    id: nil,
    joined_at: nil,
    large: nil,
    # :lazy,
    # :lfg,
    member_count: nil,
    members: %{},
    mfa_level: nil,
    name: nil,
    owner_id: nil,
    preferred_locale: nil,
    premium_subscription_count: nil,
    premium_tier: nil,
    public_updates_channel_id: nil,
    # :presences,
    region: nil,
    roles: %{},
    rules_channel_id: nil,
    splash: nil,
    system_channel_flags: nil,
    system_channel_id: nil,
    unavailable: nil,
    vanity_url_code: nil,
    verification_level: nil,
    voice_states: %{},
    widget_channel_id: nil,

    ## Not in GUILD_CREATE
    max_members: nil,
    max_presences: nil,
    embed_enabled: nil,
    widget_enabled: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          afk_channel_id: Snowflake.t() | nil,
          afk_timeout: integer(),
          application_id: Snowflake.t() | nil,
          banner: String.t() | nil,
          channels: MapSet.t(Snowflake.t()),
          default_message_notifications: non_neg_integer(),
          description: String.t() | nil,
          discovery_splash: String.t() | nil,
          embed_channel_id: Snowflake.t() | nil,
          emojis: MapSet.t(Snowflake.t()),
          explicit_content_filter: non_neg_integer(),
          features: MapSet.t(String.t()),
          icon: String.t() | nil,
          id: Snowflake.t(),
          joined_at: String.t(),
          large: boolean(),
          # lazy: boolean(),
          # lfg: nil,
          member_count: pos_integer(),
          members: %{required(Snowflake.t()) => Member.t()},
          mfa_level: integer(),
          name: String.t(),
          owner_id: String.t(),
          preferred_locale: String.t(),
          premium_subscription_count: non_neg_integer(),
          premium_tier: non_neg_integer(),
          public_updates_channel_id: Snowflake.t() | nil,
          # presences: %{required(Snowflake.t()) => Presence.t()},
          region: String.t(),
          roles: %{optional(Snowflake.t()) => Role.t()},
          rules_channel_id: Snowflake.t() | nil,
          splash: String.t() | nil,
          system_channel_flags: Guild.SystemChannelFlags.raw(),
          system_channel_id: Snowflake.t() | nil,
          unavailable: boolean(),
          vanity_url_code: String.t() | nil,
          verification_level: integer(),
          voice_states: %{optional(Snowflake.t()) => VoiceState.t()},
          widget_channel_id: Snowflake.t() | nil,

          # Not in GUILD_CREATE
          max_presences: pos_integer() | nil,
          max_members: pos_integer(),
          embed_enabled: boolean(),
          widget_enabled: boolean()
        }

  @typedoc """
    All available types that can be resolved into a guild id.
  """
  Util.typesince("0.2.1")
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
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  Util.since("0.2.1")

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
    Creates a `t:Crux.Structs.Guild/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  # TODO: Write a test
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:afk_channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:application_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:channels, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))
      |> Map.update(:emojis, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))
      |> Map.update(:features, %MapSet{}, &MapSet.new/1)
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      # :members
      |> Map.update(:owner_id, nil, &Snowflake.to_snowflake/1)
      # :roles
      |> Map.update(:system_channel_id, nil, &Snowflake.to_snowflake/1)

    # :voice_states

    guild =
      data
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

    struct(__MODULE__, guild)
  end

  defimpl String.Chars, for: Crux.Structs.Guild do
    @spec to_string(Guild.t()) :: String.t()
    def to_string(%Guild{name: name}), do: name
  end
end
