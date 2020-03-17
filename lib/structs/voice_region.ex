defmodule Crux.Structs.VoiceRegion do
  @moduledoc """
    Represents a Discord [Voice Region Object](https://discordapp.com/developers/docs/resources/voice#voice-region-object).
  """

  @behaviour Crux.Structs

  alias Crux.Structs.Util
  require Util

  Util.modulesince("0.2.3")

  defstruct(
    id: nil,
    name: nil,
    vip: nil,
    optimal: nil,
    deprecated: nil,
    custom: nil
  )

  Util.typesince("0.2.3")

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          vip: boolean(),
          optimal: boolean(),
          deprecated: boolean(),
          custom: boolean()
        }
end
