defmodule Crux.Structs.PresenceTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Presence

  test "create" do
    presence =
      %{
        "user" => %{
          "id" => "218348062828003328"
        },
        "game" => nil,
        "status" => "online"
      }
      |> Crux.Structs.create(Crux.Structs.Presence)

    assert presence == %Crux.Structs.Presence{
             user: 218_348_062_828_003_328,
             game: nil,
             status: "online"
           }
  end
end
