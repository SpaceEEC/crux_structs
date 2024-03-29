defmodule Crux.Structs.Presence.ActivityFlags do
  @moduledoc """
  Custom non discord API module helping with the usage of presence [activity flags](https://discord.com/developers/docs/topics/gateway#activity-object-activity-flags).
  """
  @moduledoc since: "0.2.3"

  use Bitwise

  flags = %{
    instance: 1 <<< 0,
    join: 1 <<< 1,
    spectate: 1 <<< 2,
    join_request: 1 <<< 3,
    sync: 1 <<< 4,
    play: 1 <<< 5,
    party_privacy_friends: 1 <<< 6,
    part_privacy_voice_channel: 1 <<< 6,
    embedded: 1 <<< 6
  }

  use Crux.Structs.BitField, flags

  @typedoc """
  Union type of all valid presence activity flags.
  """
  @typedoc since: "0.2.3"
  @type name ::
          :instance
          | :join
          | :spectate
          | :join_request
          | :sync
          | :play
          | :party_privacy_friends
          | :part_privacy_voice_channel
          | :embedded
end
