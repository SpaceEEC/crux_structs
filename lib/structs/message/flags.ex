defmodule Crux.Structs.Message.Flags do
  @moduledoc """
  Custom non discord API struct helping with the usage of [message flags](https://discord.com/developers/docs/resources/channel#message-object-message-flags).

  Currently it's only possible to edit the `suppress_embeds` flag.
  """
  @moduledoc since: "0.2.3"

  use Bitwise

  flags = %{
    crossposted: 1 <<< 0,
    is_crosspost: 1 <<< 1,
    suppress_embeds: 1 <<< 2,
    source_message_deleted: 1 <<< 3,
    urgent: 1 <<< 4
  }

  use Crux.Structs.BitField, flags

  @typedoc """
  Union type of all valid message flags.
  """
  @typedoc since: "0.2.3"
  @type name ::
          :crossposted
          | :is_crosspost
          | :suppress_embeds
          | :source_message_deleted
          | :urgent
end
