defmodule Crux.Structs.User.Flags do
  @moduledoc """
  Custom non discord API module helping with the usage of [user flags](https://discord.com/developers/docs/resources/user#user-object-user-flags).

  Discord is only providing a not documented subset of the available flags to bots.
  """
  @moduledoc since: "0.2.3"

  use Bitwise

  flags = %{
    discord_employee: 1 <<< 0,
    partnered_server_owner: 1 <<< 1,
    hypesquad_events: 1 <<< 2,
    bug_hunter_level_1: 1 <<< 3,
    # 4
    # 5
    house_bravery: 1 <<< 6,
    house_brilliance: 1 <<< 7,
    house_balance: 1 <<< 8,
    early_supporter: 1 <<< 9,
    team_user: 1 <<< 10,
    # 11
    system: 1 <<< 12,
    # 13
    bug_hunter_level_2: 1 <<< 14,
    # 15
    verified_bot: 1 <<< 16,
    early_verified_bot_developer: 1 <<< 17
  }

  use Crux.Structs.BitField, flags

  @typedoc """
  Union type of all valid user flags.
  """
  @typedoc since: "0.2.3"
  @type name ::
          :discord_employee
          | :partnered_server_owner
          | :hypesquad_events
          | :bug_hunter_level_1
          | :house_bravery
          | :house_brilliance
          | :house_balance
          | :early_supporter
          | :team_user
          | :system
          | :bug_hunter_level_2
          | :verified_bot
          | :early_verified_bot_developer
end
