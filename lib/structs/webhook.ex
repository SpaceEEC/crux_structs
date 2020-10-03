defmodule Crux.Structs.Webhook do
  @moduledoc """
    Represents a Discord [Webhook Object](https://discord.com/developers/docs/resources/webhook#webhook-object)

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """
  @moduledoc since: "0.1.6"

  @behaviour Crux.Structs

  alias Crux.Structs.{Snowflake, Util, Webhook}

  defstruct [
    :id,
    :type,
    :guild_id,
    :channel_id,
    :user,
    :name,
    :avatar,
    :token
  ]

  @type t :: %__MODULE__{
          id: Snowflake.t(),
          type: 1..2,
          guild_id: Snowflake.t() | nil,
          channel_id: Snowflake.t(),
          user: Snowflake.t() | nil,
          name: String.t() | nil,
          avatar: String.t() | nil,
          token: String.t() | nil,
        }

  @typedoc """
    All available types that can be resolved into a webhook id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Webhook.t() | Snowflake.t() | String.t()

  @doc """
    Creates a `t:Crux.Structs.Webhook.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.6"
  @spec create(data :: map()) :: t()
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update!(:channel_id, &Snowflake.to_snowflake/1)
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:user, nil, Util.map_to_id())

    struct(__MODULE__, data)
  end

  @doc ~S"""
    Converts a `t:Crux.Structs.Webhook.t/0` into its discord mention format.

  > Although the discord client does not autocomplete it for you, mentioning one still works.

    ```elixir
  iex> %Crux.Structs.Webhook{id: 218348062828003328}
  ...> |> Crux.Structs.Webhook.to_mention()
  "<@218348062828003328>"

    ```
  """
  @doc since: "0.1.6"
  @spec to_mention(webhook :: Crux.Structs.Webhook.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<@#{id}>"

  defimpl String.Chars, for: Crux.Structs.Webhook do
    @spec to_string(Webhook.t()) :: String.t()
    def to_string(%Webhook{} = data), do: Webhook.to_mention(data)
  end
end
