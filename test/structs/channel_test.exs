defmodule Crux.Structs.ChannelTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Channel

  alias Crux.Structs
  alias Crux.Structs.{Channel, Overwrite, Permissions}

  describe "create/1" do
    test "dm_channel" do
      channel =
        %{
          "id" => "242691161595183104",
          "last_message_id" => "663407680358055937",
          "last_pin_timestamp" => "2019-11-09T20:51:30.433000+00:00",
          "recipients" => [
            %{
              "avatar" => "646a356e237350bf8b8dfde15667dfc4",
              "discriminator" => "0001",
              "id" => "218348062828003328",
              "public_flags" => 512,
              "username" => "space"
            }
          ],
          "type" => 1
        }
        |> Structs.create(Channel)

      assert channel == %Channel{
               id: 242_691_161_595_183_104,
               last_message_id: 663_407_680_358_055_937,
               last_pin_timestamp: "2019-11-09T20:51:30.433000+00:00",
               recipients: MapSet.new([218_348_062_828_003_328]),
               type: 1
             }
    end

    test "guild_channel" do
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
          "id" => "250372608284033025",
          "application_id" => "222197033908436994"
        }
        |> Structs.create(Channel)

      assert channel === %Channel{
               application_id: 222_197_033_908_436_994,
               guild_id: 243_175_181_885_898_762,
               id: 250_372_608_284_033_025,
               last_message_id: 440_880_364_680_904_704,
               last_pin_timestamp: "2018-02-18T09:39:40.538000+00:00",
               name: "testing",
               nsfw: false,
               parent_id: 355_984_291_081_224_202,
               permission_overwrites: %{
                 218_348_062_828_003_328 => %Overwrite{
                   deny: Permissions.new(1024),
                   type: "member",
                   id: 218_348_062_828_003_328,
                   allow: Permissions.new(0)
                 },
                 243_175_181_885_898_762 => %Overwrite{
                   deny: Permissions.new(0),
                   type: "role",
                   id: 243_175_181_885_898_762,
                   allow: Permissions.new(0)
                 }
               },
               position: 11,
               topic: "test stuff",
               type: 0
             }
    end
  end

  test "to_string returns mention" do
    stringified =
      %Channel{id: 316_880_197_314_019_329}
      |> to_string()

    assert stringified == "<#316880197314019329>"
  end
end
