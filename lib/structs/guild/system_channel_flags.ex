defmodule Crux.Structs.Guild.SystemChannelFlags do
  @moduledoc """
  Custom non discord API struct helping with the usage of system channel flags.

  Discord is using flags in an "inverted" way here to allow all new types to be enabled by default.
  Therefore all set flags are actually disabled (as their names suggest).
  """

  alias Crux.Structs.Util
  use Bitwise

  flags = %{
    suppress_join_notifications: 1 <<< 0,
    suppress_preimum_subscriptions: 1 <<< 0
  }

  use Crux.Structs.BitField, flags

  require Util

  Util.modulesince("0.2.3")

  @typedoc """
  Union type of all valid system channel flags.
  """
  Util.typesince("0.2.3")
  @type name :: :suppress_join_notifications | :suppress_preimum_subscriptions
end
