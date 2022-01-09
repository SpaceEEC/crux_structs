defmodule Crux.Structs.Application.Flags do
  @moduledoc """
  Custom non discord API module helping with the usage of [application flags](https://discord.com/developers/docs/resources/application#application-object-application-flags).
  """
  @moduledoc since: "0.3.0"

  use Bitwise

  flags = %{
    gateway_presence: 1 <<< 12,
    gateway_presence_limited: 1 <<< 13,
    gateway_guild_members: 1 <<< 14,
    gateway_guild_members_limited: 1 <<< 15,
    verification_pending_guild_limit: 1 <<< 16,
    embedded: 1 <<< 17,
    gateway_message_content: 1 <<< 18,
    gateway_message_content_limited: 1 <<< 19
  }

  use Crux.Structs.BitField, flags

  @typedoc """
  Union type of all valide application flags.
  """
  @typedoc since: "0.3.0"
  @type name ::
          :gateway_presence
          | :gateway_presence_limited
          | :gateway_guild_members
          | :gateway_guild_members_limited
          | :verification_pending_guild_limit
          | :embedded
          | :gateway_message_content
          | :gateway_message_content_limited
end
