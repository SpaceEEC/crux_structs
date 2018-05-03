defmodule Crux.Structs.Channel do
  @moduledoc """
  Represents a Discord [Channel Object](https://discordapp.com/developers/docs/resources/channel#channel-object-channel-structure).

  List of where every property can be present:

  | Property | Text (0) | DM (1) | Voice (2) | Group (3) | Category (4) |
  | :------: | :------: | :----: | :-------: | :-------: | :----------: |
  | id       | yes      | yes    | yes       | yes       | yes          |
  | type     | `0`      | `1`    | `2`       | `3`       | `4`          |
  | guild_id | yes      | no     | yes       | no        | yes          |
  | position | yes      | no     | yes       | no        | yes          |
  | permission_overwrites | yes  | no  | yes | no        | yes          |
  | name     | yes      | no     | yes       | yes       | yes          |
  | topic    | yes      | no     | yes       | no        | yes          |
  | nsfw     | yes      | no     | no        | no        | no           |
  | last_message_id | yes | yes  | no        | yes       | no           |
  | bitrate  | no       | no     | yes       | no        | no           |
  | user_limit | no     | no     | yes       | no        | no           |
  | recipients | no     | yes<br>(One Element) | no | yes | no          |
  | icon     | no       | no     | no        | yes       | no           |
  | owner_id | no       | no     | no        | yes       | no           |
  | application_id | no | no     | no        | yes       | no           |
  | parent_id | yes     | no     | yes       | no        | no           |
  | last_pin_timestamp | yes | yes | no      | yes       | no           |

  Differences opposed to the Discord API Object:
    - `:recipients` is a MapSet of user ids
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Overwrite, Util}

  defstruct(
    id: nil,
    type: nil,
    guild_id: nil,
    position: nil,
    permission_overwrites: %{},
    name: nil,
    topic: nil,
    nsfw: nil,
    last_message_id: nil,
    bitrate: nil,
    user_limit: nil,
    recipients: %MapSet{},
    icon: nil,
    owner_id: nil,
    application_id: nil,
    parent_id: nil,
    last_pin_timestamp: nil
  )

  @type t :: %__MODULE__{
          id: integer(),
          type: integer(),
          guild_id: integer(),
          position: integer(),
          permission_overwrites: %{optional(integer()) => Overwrite.t()},
          name: String.t(),
          topic: String.t(),
          nsfw: boolean(),
          user_limit: non_neg_integer(),
          recipients: MapSet.t(integer()),
          icon: String.t(),
          owner_id: integer(),
          application_id: integer(),
          parent_id: integer(),
          last_pin_timestamp: String.t()
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
