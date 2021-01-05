defmodule Crux.Structs.Template do
  @moduledoc """
  Represents a Discord [Template Object](https://discord.com/developers/docs/resources/template#template-object).
  """
  @moduledoc since: "0.3.0"

  @behaviour Crux.Structs

  alias Crux.Structs

  alias Crux.Structs.{
    Snowflake,
    User,
    Util
  }

  defstruct [
    :code,
    :name,
    :description,
    :usage_count,
    :creator_id,
    :creator,
    :created_at,
    :updated_at,
    :source_guild_id,
    :serialized_source_guild,
    :is_dirty
  ]

  @typedoc since: "0.3.0"
  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          description: String.t() | nil,
          usage_count: integer(),
          creator_id: Snowflake.t(),
          creator: User.t(),
          created_at: String.t(),
          updated_at: String.t(),
          source_guild_id: Snowflake.t(),
          serialized_source_guild: map(),
          is_dirty: boolean() | nil
        }

  @typedoc """
  All available types that can be resolved into a template code.
  """
  @typedoc since: "0.3.0"
  @type code_resolvable() :: t() | String.t()

  @doc """
  Resolve the code of a `t:Crux.Structs.Template.t/0`.

  ## Examples

    ```elixir
  iex> %Crux.Structs.Template{code: "example"}
  ...> |> Crux.Structs.Template.resolve_code()
  "example"

  iex> "example"
  ...> |> Crux.Structs.Template.resolve_code()
  "example"

    ```
  """
  @doc since: "0.3.0"
  @spec resolve_code(code_resolvable()) :: String.t()
  def resolve_code(%__MODULE__{code: code})
      when is_binary(code) do
    code
  end

  def resolve_code(code)
      when is_binary(code) do
    code
  end

  @doc """
  Creates a `t:Crux.Structs.Template.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.3.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    template =
      data
      |> Util.atomify()
      |> Map.update!(:creator_id, &Snowflake.to_snowflake/1)
      |> Map.update!(:creator, &Structs.create(&1, User))
      |> Map.update!(:source_guild_id, &Snowflake.to_snowflake/1)

    struct(__MODULE__, template)
  end
end
