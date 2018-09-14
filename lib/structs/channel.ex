defmodule Crux.Structs.Channel do
  @moduledoc """
  Represents a Discord [Channel Object](https://discordapp.com/developers/docs/resources/channel#channel-object-channel-structure).

  List of where every property can be present:

  | Property              | Text (0) | DM (1)               | Voice (2) | Group (3) | Category (4) |
  | :-------------------: | :------: | :------------------: | :-------: | :-------: | :----------: |
  | application_id        | no       | no                   | no        | yes       | no           |
  | bitrate               | no       | no                   | yes       | no        | no           |
  | guild_id              | yes      | no                   | yes       | no        | yes          |
  | icon                  | no       | no                   | no        | yes       | no           |
  | id                    | yes      | yes                  | yes       | yes       | yes          |
  | last_message_id       | yes      | yes                  | no        | yes       | no           |
  | last_pin_timestamp    | yes      | yes                  | no        | yes       | no           |
  | name                  | yes      | no                   | yes       | yes       | yes          |
  | nsfw                  | yes      | no                   | no        | no        | no           |
  | owner_id              | no       | no                   | no        | yes       | no           |
  | parent_id             | yes      | no                   | yes       | no        | no           |
  | permission_overwrites | yes      | no                   | yes       | no        | yes          |
  | position              | yes      | no                   | yes       | no        | yes          |
  | rate_limit_per_user   | yes      | no                   | no       | no         | no           |
  | recipients            | no       | yes<br>(One Element) | no        | yes       | no           |
  | topic                 | yes      | no                   | yes       | no        | yes          |
  | type                  | `0`      | `1`                  | `2`       | `3`       | `4`          |
  | user_limit            | no       | no                   | yes       | no        | no           |

  Differences opposed to the Discord API Object:
    - `:recipients` is a MapSet of user ids
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Overwrite, Util}

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

  @type t :: %__MODULE__{
          application_id: Crux.Rest.snowflake(),
          bitrate: integer(),
          guild_id: Crux.Rest.snowflake(),
          icon: String.t(),
          id: Crux.Rest.snowflake(),
          last_message_id: Crux.Rest.snowflake(),
          last_pin_timestamp: String.t(),
          name: String.t(),
          nsfw: boolean(),
          owner_id: Crux.Rest.snowflake(),
          parent_id: Crux.Rest.snowflake(),
          permission_overwrites: %{optional(Crux.Rest.snowflake()) => Overwrite.t()},
          position: integer(),
          rate_limit_per_user: integer(),
          recipients: MapSet.t(Crux.Rest.snowflake()),
          topic: String.t(),
          type: integer(),
          user_limit: non_neg_integer()
        }

  @doc """
    Creates a `Crux.Structs.Channel` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)
      |> Map.update(:owner_id, nil, &Util.id_to_int/1)
      |> Map.update(:last_message_id, nil, &Util.id_to_int/1)
      |> Map.update(:appliparent_idcation_id, nil, &Util.id_to_int/1)
      |> Map.update(:parent_id, nil, &Util.id_to_int/1)
      |> Map.update(:permission_overwrites, %{}, &Util.raw_data_to_map(&1, Overwrite))
      |> Map.update(
        :recipients,
        %MapSet{},
        &MapSet.new(&1, fn recipient -> Map.get(recipient, :id) |> Util.id_to_int() end)
      )

    struct(__MODULE__, data)
  end

  @doc ~S"""
    Converts a `Crux.Structs.Channel` into its discord mention format.

  ## Example

    ```elixir
  iex> %Crux.Structs.Channel{id: 316880197314019329}
  ...> |> Crux.Structs.Channel.to_mention()
  "<#316880197314019329>"

  ```
  """
  @spec to_mention(user :: Crux.Structs.Channel.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<##{id}>"

  defimpl String.Chars, for: Crux.Structs.Channel do
    def to_string(%Crux.Structs.Channel{} = data), do: Crux.Structs.Channel.to_mention(data)
  end
end
