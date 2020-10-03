defmodule Crux.Structs.Invite do
  @moduledoc """
  Represents a Discord [Invite Object](https://discord.com/developers/docs/resources/invite#invite-object)

  List of what property can be present fetched with what function:

  | Property                   | `Rest.get_guild_vanity_invite/1` | `Rest.get_invite/1` | `Rest.create_channel_invite/1` | `Rest.delete_invite/1`   |
  |                            |                                  |                     | `Rest.get_channel_invites/1`   |                          |
  |                            |                                  |                     | `Rest.get_guild_invites/1`     |                          |
  | code                       | yes                              | yes                 | yes                            | yes                      |
  | guild                      | no                               | if not group dm     | if not group dm                | if not group dm          |
  | channel                    | no                               | yes                 | yes                            | yes                      |
  | inviter                    | no                               | yes                 | yes                            | yes                      |
  | uses                       | yes                              | no                  | yes                            | no                       |
  | max_uses                   | no                               | no                  | yes                            | no                       |
  | max_age                    | no                               | no                  | yes                            | no                       |
  | temporary                  | no                               | no                  | yes                            | no                       |
  | created_at                 | no                               | no                  | yes                            | no                       |
  | revoked                    | no                               | no                  | no                             | no                       |
  | approximate_presence_count | no                               | yes                 | no                             | no                       |
  | approximate_member_count   | no                               | yes                 | no                             | no                       |

  Notes:
  - `:guild` only has `:verification_level`, `:features`, `:name`, `:splash`, `:id`, and `:icon`.
  - `:channel` only has `:type`, `:id` and `:name`.
  > You can, if applicable, fetch the full structs from cache.
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Channel, Guild, User, Util}

  defstruct [
    :code,
    :guild,
    :channel,
    :inviter,
    :target_user,
    :target_user_type,
    :approximate_presence_count,
    :approximate_member_count,

    # Metadata
    :uses,
    :max_uses,
    :max_age,
    :temporary,
    :created_at
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          code: String.t(),
          guild: Guild.t(),
          channel: Channel.t(),
          inviter: User.t() | nil,
          target_user: User.t() | nil,
          target_user_type: 1 | nil,
          approximate_presence_count: integer() | nil,
          approximate_member_count: integer() | nil,

          # Metadata
          uses: integer() | nil,
          max_uses: integer() | nil,
          max_age: integer() | nil,
          temporary: boolean() | nil,
          created_at: String.t() | nil,
        }

  @doc """
    Creates a `t:Crux.Structs.Invite.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    invite =
      data
      |> Util.atomify()
      |> Map.update(:guild, nil, &Structs.create(&1, Guild))
      |> Map.update(:channel, nil, &Structs.create(&1, Channel))
      |> Map.update(:inviter, nil, &Structs.create(&1, User))
      |> Map.update(:target_user, nil, &Structs.create(&1, User))

    struct(__MODULE__, invite)
  end
end
