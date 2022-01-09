defmodule Crux.Structs.User.Flags do
  @moduledoc """
  Custom non discord API module helping with the usage of [user flags](https://discord.com/developers/docs/resources/user#user-object-user-flags).

  Discord is only providing a not documented subset of the available flags to bots.
  """
  @moduledoc since: "0.2.3"

  use Bitwise

  flags = %{
    staff: 1 <<< 0,
    partner: 1 <<< 1,
    hypesquad: 1 <<< 2,
    bug_hunter_level_1: 1 <<< 3,
    # 4
    # 5
    hypesquad_online_1: 1 <<< 6,
    hypesquad_online_2: 1 <<< 7,
    hypesquad_online_3: 1 <<< 8,
    premium_early_supporter: 1 <<< 9,
    team_pseudo_user: 1 <<< 10,
    # 11
    # 12
    # 13
    bug_hunter_level_2: 1 <<< 14,
    # 15
    verified_bot: 1 <<< 16,
    verified_developer: 1 <<< 17,
    certified_moderator: 1 <<< 18,
    bot_http_interactions: 1 <<< 19
    # 20
  }

  use Crux.Structs.BitField, flags

  @typedoc """
  Union type of all valid user flags.
  """
  @typedoc since: "0.2.3"
  @type name ::
          :staff
          | :partner
          | :hypesquad
          | :bug_hunter_level_1
          | :hypesquad_online_1
          | :hypesquad_online_2
          | :hypesquad_online_3
          | :premium_early_supporter
          | :team_pseudo_user
          | :bug_hunter_level_2
          | :verified_bot
          | :verified_developer
          | :certified_moderator
          | :bot_http_interactions
end
