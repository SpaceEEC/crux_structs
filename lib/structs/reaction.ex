defmodule Crux.Structs.Reaction do
  @moduledoc """
    Represents a Discord [Reaction Object](https://discordapp.com/developers/docs/resources/channel#reaction-object).
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Emoji, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    count: nil,
    me: nil,
    emoji: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          count: integer(),
          me: boolean,
          emoji: Emoji.t()
        }

  @doc """
    Creates a `t:Crux.Structs.Presence.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    reaction =
      data
      |> Util.atomify()
      |> Map.update!(:emoji, &Structs.create(&1, Emoji))

    struct(__MODULE__, reaction)
  end
end
