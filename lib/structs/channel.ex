defmodule Crux.Structs.Channel do
  @moduledoc """
  Represents a Discord [Channel Object](https://discordapp.com/developers/docs/resources/channel#channel-object-channel-structure).

  List of where every property can be present:

  | Property              | Text (0) | DM (1)               | Voice (2) | Group (3) | Category (4) | News (5) |
  | :-------------------: | :------: | :------------------: | :-------: | :-------: | :----------: | :------: |
  | application_id        | no       | no                   | no        | yes       | no           | no       |
  | bitrate               | no       | no                   | yes       | no        | no           | no       |
  | guild_id              | yes      | no                   | yes       | no        | yes          | yes      |
  | icon                  | no       | no                   | no        | yes       | no           | no       |
  | id                    | yes      | yes                  | yes       | yes       | yes          | yes      |
  | last_message_id       | yes      | yes                  | no        | yes       | no           | yes      |
  | last_pin_timestamp    | yes      | yes                  | no        | yes       | no           | yes      |
  | name                  | yes      | no                   | yes       | yes       | yes          | yes      |
  | nsfw                  | yes      | no                   | no        | no        | no           | yes      |
  | owner_id              | no       | no                   | no        | yes       | no           | no       |
  | parent_id             | yes      | no                   | yes       | no        | no           | yes      |
  | permission_overwrites | yes      | no                   | yes       | no        | yes          | yes      |
  | position              | yes      | no                   | yes       | no        | yes          | yes      |
  | rate_limit_per_user   | yes      | no                   | no       | no         | no           | no       |
  | recipients            | no       | yes<br>(One Element) | no        | yes       | no           | no       |
  | topic                 | yes      | no                   | yes       | no        | yes          | yes      |
  | type                  | `0`      | `1`                  | `2`       | `3`       | `4`          | `5`      |
  | user_limit            | no       | no                   | yes       | no        | no           | no       |

  Differences opposed to the Discord API Object:
    - `:recipients` is a MapSet of user ids
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Overwrite, Snowflake, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    application_id: nil,
    bitrate: nil,
    guild_id: nil,
    icon: nil,
    id: nil,
    last_message_id: nil,
    last_pin_timestamp: nil,
    name: nil,
    nsfw: nil,
    owner_id: nil,
    parent_id: nil,
    permission_overwrites: %{},
    position: nil,
    rate_limit_per_user: nil,
    recipients: %MapSet{},
    topic: nil,
    type: nil,
    user_limit: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          application_id: Snowflake.t(),
          bitrate: integer(),
          guild_id: Snowflake.t(),
          icon: String.t(),
          id: Snowflake.t(),
          last_message_id: Snowflake.t(),
          last_pin_timestamp: String.t(),
          name: String.t(),
          nsfw: boolean(),
          owner_id: Snowflake.t(),
          parent_id: Snowflake.t(),
          permission_overwrites: %{optional(Snowflake.t()) => Overwrite.t()},
          position: integer(),
          rate_limit_per_user: integer(),
          recipients: MapSet.t(Snowflake.t()),
          topic: String.t(),
          type: integer(),
          user_limit: non_neg_integer()
        }

  @doc """
    Creates a `t:Crux.Structs.Channel.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    channel =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:owner_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:last_message_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:appliparent_idcation_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:parent_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:permission_overwrites, %{}, &Util.raw_data_to_map(&1, Overwrite))
      |> Map.update(:recipients, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))

    struct(__MODULE__, channel)
  end

  @doc ~S"""
    Converts a `t:Crux.Structs.Channel.t/0` into its discord mention format.

  ## Example

    ```elixir
  iex> %Crux.Structs.Channel{id: 316880197314019329}
  ...> |> Crux.Structs.Channel.to_mention()
  "<#316880197314019329>"

  ```
  """
  @spec to_mention(user :: Crux.Structs.Channel.t()) :: String.t()
  Util.since("0.1.1")
  def to_mention(%__MODULE__{id: id}), do: "<##{id}>"

  defimpl String.Chars, for: Crux.Structs.Channel do
    alias Crux.Structs.Channel

    @spec to_string(Channel.t()) :: String.t()
    def to_string(%Channel{} = data), do: Channel.to_mention(data)
  end
end
