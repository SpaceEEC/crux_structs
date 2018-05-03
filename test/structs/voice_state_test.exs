defmodule Crux.Structs.VoiceStateTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.VoiceState

  test "create" do
    voice_state =
      %{
        "guild_id" => "81384788765712384",
        "channel_id" => nil,
        "user_id" => "218348062828003328",
        "session_id" => "3cacd55501478cf493df4d6108e5df45",
        "deaf" => false,
        "mute" => false,
        "self_mute" => false,
        "self_deaf" => false,
        "self_video" => false,
        "suppress" => false
      }
      |> Crux.Structs.VoiceState.create()

    assert voice_state == %Crux.Structs.VoiceState{
             guild_id: 81_384_788_765_712_384,
             channel_id: nil,
             user_id: 218_348_062_828_003_328,
             session_id: "3cacd55501478cf493df4d6108e5df45",
             deaf: false,
             mute: false,
             self_mute: false,
             self_deaf: false,
             suppress: false
           }
  end
end
