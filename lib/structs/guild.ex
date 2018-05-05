defmodule Crux.Structs.Guild do
  @moduledoc """
  Represents a Discord [Guild Object](https://discordapp.com/developers/docs/resources/guild#guild-object-guild-structure).

  Differences opposed to the Discord API Object:
  - `:emojis` is a `MapSet` of emoji ids
  - `:channels` is a `MapSet` of channel ids
  - `:presences` does not exists at all
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Member, Role, Util, VoiceState}

  defstruct(
    id: nil,
    name: nil,
    icon: nil,
    splash: nil,
    owner_id: nil,
    region: nil,
    afk_channel_id: nil,
    afk_timeout: nil,
    embed_enabled: nil,
    verification_level: nil,
    default_message_notifications: nil,
    explicit_content_filter: nil,
    roles: %{},
    emojis: %MapSet{},
    features: %MapSet{},
    mfa_level: nil,
    application_id: nil,
    widget_enabled: nil,
    joined_at: nil,
    large: nil,
    unavailable: nil,
    member_count: nil,
    voice_states: %{},
    members: %{},
    channels: %MapSet{}
    # presences: %{}
  )

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          icon: String.t() | nil,
          owner_id: String.t(),
          region: String.t(),
          afk_channel_id: integer() | nil,
          afk_timeout: integer(),
          embed_enabled: boolean(),
          verification_level: integer(),
          default_message_notifications: integer(),
          explicit_content_filter: integer(),
          roles: %{optional(integer()) => Role.t()},
          emojis: MapSet.t(integer()),
          features: MapSet.t(String.t()),
          mfa_level: integer(),
          application_id: integer() | nil,
          widget_enabled: boolean(),
          joined_at: String.t(),
          large: boolean(),
          unavailable: boolean(),
          member_count: integer(),
          voice_states: %{optional(integer()) => VoiceState.t()},
          members: %{optional(integer()) => Member.t()},
          channels: MapSet.t(integer())
          # presences: %{optional(integer()) => Presence.t()}
        }

  @doc """
    Creates a `Crux.Structs.Guild` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  # TODO: Write a doctest
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)

    data =
      data
      |> Map.update(:owner_id, nil, &Util.id_to_int/1)
      |> Map.update(:afk_channel_id, nil, &Util.id_to_int/1)
      |> Map.update(:roles, %{}, &Util.raw_data_to_map(&1, Role))
      |> Map.update(
        :emojis,
        %MapSet{},
        &MapSet.new(&1, fn emoji -> Map.get(emoji, :id) |> Util.id_to_int() end)
      )
      |> Map.update(:features, [], &MapSet.new/1)
      |> Map.update(:application_id, nil, &Util.id_to_int/1)
      |> Map.update(
        :voice_states,
        [],
        &Enum.map(&1, fn voice_state -> Map.put(voice_state, :guild_id, data.id) end)
      )
      |> Map.update!(:voice_states, &Util.raw_data_to_map(&1, VoiceState, :user_id))
      |> Map.update(
        :members,
        [],
        &Enum.map(&1, fn member -> Map.put(member, :guild_id, data.id) end)
      )
      |> Map.update!(:members, &Util.raw_data_to_map(&1, Member, :user))
      |> Map.update(
        :channels,
        %MapSet{},
        &MapSet.new(&1, fn channel -> Map.get(channel, :id) |> Util.id_to_int() end)
      )

    struct(__MODULE__, data)
  end

  defimpl String.Chars, for: Crux.Structs.Guild do
    def to_string(%Crux.Structs.Guild{name: name}), do: name
  end
end
