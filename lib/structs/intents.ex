defmodule Crux.Structs.Intents do
  @moduledoc """
  Custom non discord api struct to help with working with intents.

  For more information see the [Discord Developer Documentation](https://discord.com/developers/docs/topics/gateway#gateway-intents).
  """
  @moduledoc since: "0.3.0"

  use Bitwise

  intents = %{
    guilds: 1 <<< 0,
    guild_members: 1 <<< 1,
    guild_bans: 1 <<< 2,
    guild_emojis: 1 <<< 3,
    guild_integrations: 1 <<< 4,
    guild_webhooks: 1 <<< 5,
    guild_invites: 1 <<< 6,
    guild_voice_states: 1 <<< 7,
    guild_presences: 1 <<< 8,
    guild_messages: 1 <<< 9,
    guild_message_reactions: 1 <<< 10,
    guild_message_typing: 1 <<< 11,
    direct_messages: 1 <<< 12,
    direct_message_reactions: 1 <<< 13,
    direct_message_typing: 1 <<< 14
  }

  use Crux.Structs.BitField, intents

  @typedoc """
  Union type of all valid intent name atoms.
  """
  @typedoc since: "0.3.0"
  @type name ::
          :guilds
          | :guild_members
          | :guild_bans
          | :guild_emojis
          | :guild_integrations
          | :guild_webhooks
          | :guild_invites
          | :guild_voice_states
          | :guild_presences
          | :guild_messages
          | :guild_message_reactions
          | :guild_message_typing
          | :direct_messages
          | :direct_message_reactions
          | :direct_message_typing
end
