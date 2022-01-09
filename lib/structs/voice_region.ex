defmodule Crux.Structs.VoiceRegion do
  @moduledoc """
  Represents a Discord [Voice Region Object](https://discord.com/developers/docs/resources/voice#voice-region-object).
  """
  @moduledoc since: "0.2.3"

  @behaviour Crux.Structs

  defstruct [
    :id,
    :name,
    :optimal,
    :deprecated,
    :custom
  ]

  @typedoc since: "0.2.3"
  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          optimal: boolean(),
          deprecated: boolean(),
          custom: boolean()
        }
end
