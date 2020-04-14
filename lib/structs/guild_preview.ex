defmodule Crux.Structs.GuildPreview do
  @moduledoc """
  Represents a Discord [Guild Preview Object](TODO)

  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Emoji, Snowflake, Util}
  require Util

  Util.modulesince("0.2.3")

  defstruct(
    id: nil,
    name: nil,
    icon: nil,
    splash: nil,
    discovery_splash: nil,
    emojis: %{},
    features: [],
    approximate_member_count: nil,
    approximate_presence_count: nil,
    description: nil
  )

  Util.typesince("0.2.3")

  @type t :: %__MODULE__{
          id: Snowflake.t(),
          name: String.t(),
          icon: String.t() | nil,
          splash: String.t() | nil,
          discovery_splash: String.t() | nil,
          emojis: %{required(Snowflake.t()) => Emoji.t()},
          features: [String.t()],
          approximate_member_count: non_neg_integer(),
          approximate_presence_count: non_neg_integer(),
          description: String.t()
        }

  @doc """
  Creates a `t:Crux.Structs.GuildPreview.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:emojis, %{}, &Util.raw_data_to_map(&1, Emoji))

    struct(__MODULE__, data)
  end

  defimpl String.Chars, for: Crux.Structs.GuildPreview do
    @spec to_string(Crux.Structs.GuildPreview.t()) :: String.t()
    def to_string(%Crux.Structs.GuildPreview{name: name}), do: name
  end
end
