defmodule Crux.Structs.Reaction do
  @moduledoc """
    Represents a Discord [Reaction Object](https://discord.com/developers/docs/resources/channel#reaction-object).
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Emoji, Reaction, Snowflake, Util}

  defstruct [
    :count,
    :me,
    :emoji
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          count: integer(),
          me: boolean,
          emoji: Emoji.t()
        }

  @typedoc """
    All available types that can be resolved into a reaction / emoji id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Reaction.t() | Emoji.t() | Snowflake.t() | String.t()

  @doc """
    Resolves the id of a `t:Crux.Structs.Reaction.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

    ```elixir
    iex> %Crux.Structs.Reaction{emoji: %Crux.Structs.Emoji{id: 618731477143912448}}
    ...> |> Crux.Structs.Reaction.resolve_id()
    618731477143912448

    iex> %Crux.Structs.Emoji{id: 618731477143912448}
    ...> |> Crux.Structs.Reaction.resolve_id()
    618731477143912448

    iex> 618731477143912448
    ...> |> Crux.Structs.Reaction.resolve_id()
    618731477143912448

    iex> "618731477143912448"
    ...> |> Crux.Structs.Reaction.resolve_id()
    618731477143912448

    ```
  """
  @doc since: "0.2.1"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  defdelegate resolve_id(resolvable), to: Emoji

  @doc """
    Creates a `t:Crux.Structs.Presence.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    reaction =
      data
      |> Util.atomify()
      |> Map.update!(:emoji, &Structs.create(&1, Emoji))

    struct(__MODULE__, reaction)
  end
end
