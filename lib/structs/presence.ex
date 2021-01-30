defmodule Crux.Structs.Presence do
  @moduledoc """
    Represents a Discord [Presence Object](https://discord.com/developers/docs/topics/gateway#presence-update-presence-update-event-fields).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Emoji, Presence, Snowflake, User, Util}
  require Snowflake

  defstruct [
    :user,
    :guild_id,
    :status,
    :activities,
    :client_status
  ]

  @typedoc """
  Represents an [Activity Object](https://discord.com/developers/docs/topics/gateway#activity-object).
  """
  @typedoc since: "0.2.3"
  @type activity :: %{
          required(:name) => String.t(),
          required(:type) => integer(),
          optional(:url) => nil | String.t(),
          required(:created_at) => integer(),
          optional(:timestamps) => %{start: integer(), stop: integer()},
          optional(:application_id) => Snowflake.t(),
          optional(:details) => String.t() | nil,
          optional(:state) => String.t() | nil,
          optional(:emoji) => Emoji.t() | nil,
          optional(:party) => %{id: String.t(), size: [integer()]},
          optional(:assets) => %{
            large_image: String.t(),
            large_text: String.t(),
            small_image: String.t(),
            small_text: String.t()
          },
          optional(:secrets) => %{
            join: String.t(),
            spectate: String.t(),
            match: String.t()
          },
          optional(:instance) => boolean(),
          optional(:flags) => Presence.ActivityFlags.t()
        }

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          user: Snowflake.t(),
          guild_id: Snowflake.t() | nil,
          status: String.t(),
          activities: [activity()],
          client_status: %{required(atom()) => atom()}
        }

  @typedoc """
    All available types that can be resolved into a user id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable :: User.id_resolvable()

  @doc """
  Resolves the id of a `t:Crux.Structs.Presence.t/0`

  > Automatically invoked by `Crux.Structs.resolve_id/2`

  ```elixir
  iex> %Crux.Structs.Presence{user: 218348062828003328}
  ...> |> Crux.Structs.Presence.resolve_id()
  218348062828003328
  ```

  For more examples see `Crux.Structs.User.resolve_id/1`
  """
  @doc since: "0.2.1"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  defdelegate resolve_id(resolvable), to: User

  @doc """
    Creates a `t:Crux.Structs.Presence.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    presence =
      data
      |> Util.atomify()
      |> Map.update!(:user, Util.map_to_id())
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:activities, nil, fn activities ->
        Enum.map(activities, &create_activity/1)
      end)

    struct(__MODULE__, presence)
  end

  defp create_activity(%{application_id: application_id} = activity)
       when not Snowflake.is_snowflake(application_id) do
    activity
    |> Map.update!(:application_id, &Snowflake.to_snowflake/1)
    |> create_activity()
  end

  defp create_activity(%{flags: flags} = activity)
       when not is_integer(flags) do
    activity
    |> Map.update!(:flags, &Presence.ActivityFlags.resolve/1)
    |> create_activity()
  end

  defp create_activity(%{emoji: nil} = activity) do
    activity
  end

  defp create_activity(%{emoji: _emoji} = activity) do
    Map.update!(activity, :emoji, &Structs.create(&1, Emoji))
  end

  defp create_activity(activity) do
    activity
  end
end
