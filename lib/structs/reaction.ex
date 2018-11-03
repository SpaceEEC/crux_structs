defmodule Crux.Structs.Reaction do
  @moduledoc since: "0.1.0"
  @moduledoc """
    Represents a Discord [Reaction Object](https://discordapp.com/developers/docs/resources/channel#reaction-object).
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Util, Emoji}

  defstruct(
    count: nil,
    me: nil,
    emoji: nil
  )

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          count: integer(),
          me: boolean,
          emoji: Emoji.t()
        }

  @doc """
    Creates a `Crux.Structs.Presence` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:emoji, &Structs.create(&1, Emoji))

    struct(__MODULE__, data)
  end
end
