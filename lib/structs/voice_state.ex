defmodule Crux.Structs.VoiceState do
  @moduledoc """
    Represents a Discord [Voice State Object](https://discordapp.com/developers/docs/resources/voice#voice-state-object-voice-state-structure)
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Snowflake, User, Util}
  require Util
  require Snowflake

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
          guild_id: Snowflake.t(),
          channel_id: Snowflake.t() | nil,
          user_id: Snowflake.t(),
          session_id: String.t(),
          deaf: boolean(),
          mute: boolean(),
          self_deaf: boolean(),
          self_mute: boolean(),
          suppress: boolean()
        }

  @typedoc """
    All available types that can be resolved into a user id.
  """
  Util.typesince("0.2.1")
  @type id_resolvable() :: User.id_resolvable()

  @doc """
    Resolves the id of a `t:Crux.Structs.VoiceState.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

    For examples see `Crux.Structs.User.resolve_id/1`.

  """
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  Util.since("0.2.1")
  defdelegate resolve_id(data), to: User

  @doc """
    Creates a `t:Crux.Structs.VoiceState.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    voice_state =
      data
      |> Util.atomify()
      |> Map.update!(:guild_id, &Snowflake.to_snowflake/1)
      |> Map.update(:channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update!(:user_id, &Snowflake.to_snowflake/1)

    struct(__MODULE__, voice_state)
  end
end
