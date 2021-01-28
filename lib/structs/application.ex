defmodule Crux.Structs.Application do
  @moduledoc """
  Represents a Discord [Application Object](https://discord.com/developers/docs/topics/oauth2#application-object).
  """
  @moduledoc since: "0.3.0"

  @behaviour Crux.Structs

  alias Crux.Structs

  alias Crux.Structs.{
    Application,
    Snowflake,
    User,
    Util
  }

  defstruct [
    :id,
    :name,
    :icon,
    :description,
    :rpc_origins,
    :bot_public,
    :bot_require_code_grant,
    :owner,
    :summary,
    :verify_key,
    :team,
    :guild_id,
    :primary_sku_id,
    :slug,
    :cover_image,
    :flags
  ]

  @typedoc since: "0.3.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          icon: String.t() | nil,
          description: String.t(),
          rpc_origins: [String.t()] | nil,
          bot_public: boolean(),
          bot_require_code_grant: boolean(),
          owner: User.t(),
          summary: String.t(),
          team: team() | nil,
          guild_id: Snowflake.t(),
          primary_sku_id: Snowflake.t(),
          slug: String.t(),
          cover_image: String.t(),
          flags: non_neg_integer()
        }

  @typedoc since: "0.3.0"
  @type team :: %{
          id: Snowflake.t(),
          icon: String.t() | nil,
          members: %{
            required(Snowflake.t()) => %{
              membership_state: 1..2,
              permissions: [String.t()],
              team_id: Snowflake.t(),
              user: User.t()
            }
          },
          owner_user_id: Snowflake.t()
        }

  @typedoc """
  All available types that can be resolved into an application id.
  """
  @typedoc since: "0.3.0"
  @type id_resolvable() :: Application.t() | Snowflake.t() | String.t()

  @doc """
  Creates a `t:Crux.Structs.Application.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.3.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    application =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:owner, nil, &Structs.create(&1, User))
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:primary_sku_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update(:team, nil, &transform_team/1)

    struct(__MODULE__, application)
  end

  defp transform_team(nil), do: nil

  defp transform_team(team) do
    team
    |> Map.update!(:id, &Snowflake.to_snowflake/1)
    |> Map.update!(:owner_user_id, &Snowflake.to_snowflake/1)
    |> Map.update!(
      :members,
      fn members ->
        Map.new(members, fn member ->
          member =
            member
            |> Map.update!(:team_id, &Snowflake.to_snowflake/1)
            |> Map.update!(:user, &Structs.create(&1, User))

          {member.user.id, member}
        end)
      end
    )
  end
end
