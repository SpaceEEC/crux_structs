defmodule Crux.Structs.VoiceRegionTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.VoiceRegion

  alias Crux.Structs
  alias Crux.Structs.VoiceRegion

  test "create/1" do
    voice_region =
      %{
        "id" => "us-west",
        "name" => "US West",
        "vip" => false,
        "custom" => false,
        "deprecated" => false,
        "optimal" => false
      }
      |> Structs.create(VoiceRegion)

    assert voice_region == %VoiceRegion{
             id: "us-west",
             name: "US West",
             vip: false,
             custom: false,
             deprecated: false,
             optimal: false
           }
  end
end
