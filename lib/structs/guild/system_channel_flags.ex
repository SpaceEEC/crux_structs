defmodule Crux.Structs.Guild.SystemChannelFlags do
  @moduledoc """
  Custom non discord API module helping with the usage of [system channel flags](https://discord.com/developers/docs/resources/guild#guild-object-system-channel-flags).

  Discord is using flags in an "inverted" way here to allow all new types to be enabled by default.
  Therefore all set flags are actually disabled (as their names suggest).
  """
  @moduledoc since: "0.2.3"

  use Bitwise

  flags = %{
    suppress_join_notifications: 1 <<< 0,
    suppress_premium_subscriptions: 1 <<< 1,
    suppress_guild_reminder_notifications: 1 <<< 2,
    suppress_join_notification_replies: 1 <<< 3
  }

  use Crux.Structs.BitField, flags

  @typedoc """
  Union type of all valid system channel flags.
  """
  @typedoc since: "0.2.3"
  @type name ::
          :suppress_join_notifications
          | :suppress_premium_subscriptions
          | :suppress_guild_reminder_notifications
          | :suppress_join_notification_replies
end
