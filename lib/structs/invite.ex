defmodule Crux.Structs.Invite do
  @moduledoc """
  Represents a Discord [Invite Object](https://discordapp.com/developers/docs/resources/invite#invite-object)

  List of what property can be present fetched with what function:

  | Property                   | `Rest.get_invite/1` | `Rest.create_channel_invite/1` | `Rest.delete_invite/1`   |
  |                            |                     | `Rest.get_channel_invites/1`   |                          |
  |                            |                     | `Rest.get_guild_invites/1`     |                          |
  | code                       | yes                 | yes                            | yes                      |
  | guild                      | if not group dm     | if not group dm                | if not group dm          |
  | channel                    | yes                 | yes                            | yes                      |
  | inviter                    | yes                 | yes                            | yes                      |
  | uses                       | no                  | yes                            | no                       |
  | max_uses                   | no                  | yes                            | no                       |
  | max_age                    | no                  | yes                            | no                       |
  | temporary                  | no                  | yes                            | no                       |
  | created_at                 | no                  | yes                            | no                       |
  | revoked                    | no                  | no                             | no                       |
  | approximate_presence_count | yes                 | no                             | no                       |
  | approximate_member_count   | yes                 | no                             | no                       |

  Notes:
  - `:guild` only has`:verification_level`, `:features`, `:name`, `:splash`, `:id`, and `:icon`.
  - `:channel` only has `:type`, `:id` and `:name`.
  > You can, if applicable, fetch the full structs from cache.
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Channel, Guild, User, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    # always
    code: nil,
    guild: nil,
    channel: nil,
    # only when fetched via get_channel_invites
    inviter: nil,
    uses: nil,
    max_uses: nil,
    max_age: nil,
    temporary: nil,
    created_at: nil,
    revoked: nil,
    approximate_presence_count: nil,
    approximate_member_count: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          code: String.t(),
          guild: Guild.t(),
          channel: Channel.t(),
          inviter: User.t() | nil,
          uses: integer() | nil,
          max_uses: integer() | nil,
          max_age: integer() | nil,
          temporary: boolean() | nil,
          created_at: String.t() | nil,
          revoked: boolean() | nil,
          approximate_presence_count: integer() | nil,
          approximate_member_count: integer() | nil
        }

  @doc """
    Creates a `t:Crux.Structs.Invite.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    invite =
      data
      |> Util.atomify()
      |> Map.update(:guild, nil, &Structs.create(&1, Guild))
      |> Map.update(:inviter, nil, &Structs.create(&1, User))
      |> Map.update(:channel, nil, &Structs.create(&1, Channel))

    struct(__MODULE__, invite)
  end
end
