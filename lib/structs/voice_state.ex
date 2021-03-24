defmodule Crux.Structs.VoiceState do
  @moduledoc """
  Represents a Discord [Voice State Object](https://discord.com/developers/docs/resources/voice#voice-state-object)
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Member, Snowflake, User, Util}

  defstruct [
    :guild_id,
    :channel_id,
    :user_id,
    :member,
    :session_id,
    :deaf,
    :mute,
    :self_deaf,
    :self_mute,
    :self_stream,
    :self_video,
    :suppress
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          guild_id: Snowflake.t(),
          channel_id: Snowflake.t() | nil,
          user_id: Snowflake.t(),
          member: Member.t(),
          session_id: String.t(),
          deaf: boolean(),
          mute: boolean(),
          self_deaf: boolean(),
          self_mute: boolean(),
          self_stream: boolean(),
          suppress: boolean()
        }

  @typedoc """
  All available types that can be resolved into a user id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: User.id_resolvable()

  @doc """
  Resolves the id of a `t:Crux.Structs.VoiceState.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

  ```elixir
  iex> %Crux.Structs.VoiceState{user_id: 218348062828003328}
  ...> |> Crux.Structs.VoiceState.resolve_id()
  218348062828003328
  ```

  For more examples see `Crux.Structs.User.resolve_id/1`.

  """
  @doc since: "0.2.1"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  defdelegate resolve_id(resolvable), to: User

  @doc """
  Creates a `t:Crux.Structs.VoiceState.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    voice_state =
      data
      |> Util.atomify()
      |> Map.update!(:guild_id, &Snowflake.to_snowflake/1)
      |> Map.update(:channel_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update!(:user_id, &Snowflake.to_snowflake/1)
      |> Map.update(:member, nil, &Structs.create(&1, Member))

    struct(__MODULE__, voice_state)
  end
end
