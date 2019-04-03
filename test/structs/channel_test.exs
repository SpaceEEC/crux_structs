defmodule Crux.Structs.ChannelTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Channel

  test "create" do
    channel =
      %{
        "guild_id" => "243175181885898762",
        "name" => "testing",
        "permission_overwrites" => [
          %{"deny" => 0, "type" => "role", "id" => "243175181885898762", "allow" => 0},
          %{"deny" => 1024, "type" => "member", "id" => "218348062828003328", "allow" => 0}
        ],
        "last_pin_timestamp" => "2018-02-18T09:39:40.538000+00:00",
        "topic" => "test stuff",
        "parent_id" => "355984291081224202",
        "nsfw" => false,
        "position" => 11,
        "last_message_id" => "440880364680904704",
        "type" => 0,
        "id" => "250372608284033025"
      }
      |> Crux.Structs.create(Crux.Structs.Channel)

    assert channel === %Crux.Structs.Channel{
             guild_id: 243_175_181_885_898_762,
             id: 250_372_608_284_033_025,
             last_message_id: 440_880_364_680_904_704,
             last_pin_timestamp: "2018-02-18T09:39:40.538000+00:00",
             name: "testing",
             nsfw: false,
             parent_id: 355_984_291_081_224_202,
             permission_overwrites: %{
               218_348_062_828_003_328 => %Crux.Structs.Overwrite{
                 deny: 1024,
                 type: "member",
                 id: 218_348_062_828_003_328,
                 allow: 0
               },
               243_175_181_885_898_762 => %Crux.Structs.Overwrite{
                 deny: 0,
                 type: "role",
                 id: 243_175_181_885_898_762,
                 allow: 0
               }
             },
             position: 11,
             recipients: %MapSet{},
             topic: "test stuff",
             type: 0
           }
  end

  test "to_string returns mention" do
    stringified =
      %Crux.Structs.Channel{id: 316_880_197_314_019_329}
      |> to_string()

    assert stringified == "<#316880197314019329>"
  end
end
