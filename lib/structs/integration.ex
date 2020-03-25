defmodule Crux.Structs.Integration do
  @moduledoc """
    Represents a Discord [Integration Object](https://discordapp.com/developers/docs/resources/guild#integration-object).
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Integration, Snowflake, Util}
  require Util

  Util.modulesince("0.2.2")

  defstruct(
    id: nil,
    name: nil,
    type: nil,
    enabled: nil,
    syncing: nil,
    role_id: nil,
    enable_emoticons: nil,
    expire_behavior: nil,
    expire_grace_period: nil,
    user: nil,
    account: nil,
    synced_at: nil
  )

  Util.typesince("0.2.2")

  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          type: String.t(),
          enabled: boolean(),
          syncing: boolean(),
          role_id: Snowflake.t(),
          enable_emoticons: boolean() | nil,
          expire_behavior: 0..1,
          expire_grace_period: integer(),
          user: Snowflake.t(),
          account: map(),
          synced_at: String.t()
        }

  @typedoc """
    All available types that can be resolved into an integration id.
  """
  Util.typesince("0.2.3")
  @type id_resolvable() :: Integration.t() | Snowflake.t()

  @doc """
    Creates a `t:Crux.Structs.Integration.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.2.2")

  def create(data) do
    integration =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:role_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:user, nil, Util.map_to_id())
      |> Map.update(:account, nil, fn account ->
        Map.update(account, :id, nil, &Snowflake.to_snowflake/1)
      end)

    struct(__MODULE__, integration)
  end
end
