defmodule Crux.Structs.VoiceState do
  @moduledoc """
    Represents a Discord [Voice State Object](https://discordapp.com/developers/docs/resources/voice#voice-state-object-voice-state-structure)
  """

  @behaviour Crux.Structs

  alias Crux.Structs.Util
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    guild_id: nil,
    channel_id: nil,
    user_id: nil,
    session_id: nil,
    deaf: nil,
    mute: nil,
    self_deaf: nil,
    self_mute: nil,
    # Can bots even do that?
    suppress: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          guild_id: Crux.Rest.snowflake(),
          channel_id: Crux.Rest.snowflake() | nil,
          user_id: Crux.Rest.snowflake(),
          session_id: String.t(),
          deaf: boolean(),
          mute: boolean(),
          self_deaf: boolean(),
          self_mute: boolean(),
          suppress: boolean()
        }

  @doc """
    Creates a `Crux.Structs.VoiceState` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    voice_state =
      data
      |> Util.atomify()
      |> Map.update!(:guild_id, &Util.id_to_int/1)
      |> Map.update(:channel_id, nil, &Util.id_to_int/1)
      |> Map.update!(:user_id, &Util.id_to_int/1)

    struct(__MODULE__, voice_state)
  end
end
