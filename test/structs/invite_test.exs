defmodule Crux.Structs.InviteTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Invite

  test "create" do
    invite =
      %{
        "code" => "discord-api",
        "guild" => %{
          "verification_level" => 3,
          "features" => [
            "VIP_REGIONS",
            "VANITY_URL",
            "INVITE_SPLASH"
          ],
          "name" => "Discord API",
          "splash" => nil,
          "id" => "81384788765712384",
          "icon" => "a8eccf1628b1e739d535a813f279e905"
        },
        "channel" => %{
          "type" => 0,
          "id" => "381898062269775883",
          "name" => "rules"
        }
      }
      |> Crux.Structs.Invite.create()

    assert invite == %Crux.Structs.Invite{
             channel: %Crux.Structs.Channel{
               id: 381_898_062_269_775_883,
               name: "rules",
               type: 0
             },
             code: "discord-api",
             guild: %Crux.Structs.Guild{
               features: MapSet.new(["INVITE_SPLASH", "VANITY_URL", "VIP_REGIONS"]),
               icon: "a8eccf1628b1e739d535a813f279e905",
               id: 81_384_788_765_712_384,
               name: "Discord API",
               splash: nil,
               verification_level: 3
             }
           }
  end
end
