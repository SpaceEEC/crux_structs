defmodule Crux.Structs.MessageTest do
  use ExUnit.Case, async: true

  doctest Crux.Structs.Message

  test "create" do
    message =
      %{
        "attachments" => [],
        "author" => %{
          "avatar" => "646a356e237350bf8b8dfde15667dfc4",
          "discriminator" => "0001",
          "id" => "218348062828003328",
          "username" => "space"
        },
        "member" => %{
          "roles" => ["222442681798885376", "273204842510548993", "376146940762783746"],
          "nick" => "nickname",
          "mute" => false,
          "joined_at" => "2017-03-30T20:11:13.456000+00:00",
          "deaf" => false
        },
        "channel_id" => "250372608284033025",
        "content" => "hello there!",
        "edited_timestamp" => nil,
        "embeds" => [],
        "id" => "440947000364630017",
        "mention_everyone" => false,
        "mention_roles" => [],
        "mentions" => [
          %{
            "avatar" => "646a356e237350bf8b8dfde15667dfc4",
            "discriminator" => "0001",
            "id" => "218348062828003328",
            "username" => "space",
            "member" => %{
              "roles" => ["222442681798885376", "273204842510548993", "376146940762783746"],
              "nick" => "nickname",
              "mute" => false,
              "joined_at" => "2017-03-30T20:11:13.456000+00:00",
              "deaf" => false
            }
          }
        ],
        "pinned" => false,
        "timestamp" => "2018-05-01T18:45:57.286000+00:00",
        "tts" => false,
        "type" => 0
      }
      |> Crux.Structs.create(Crux.Structs.Message)

    assert message == %Crux.Structs.Message{
             attachments: [],
             author: %Crux.Structs.User{
               username: "space",
               discriminator: "0001",
               avatar: "646a356e237350bf8b8dfde15667dfc4",
               id: 218_348_062_828_003_328
             },
             member: %Crux.Structs.Member{
               roles:
                 MapSet.new([
                   222_442_681_798_885_376,
                   273_204_842_510_548_993,
                   376_146_940_762_783_746
                 ]),
               nick: "nickname",
               mute: false,
               joined_at: "2017-03-30T20:11:13.456000+00:00",
               deaf: false,
               user: 218_348_062_828_003_328
             },
             channel_id: 250_372_608_284_033_025,
             content: "hello there!",
             edited_timestamp: nil,
             embeds: [],
             id: 440_947_000_364_630_017,
             mention_everyone: false,
             mention_roles: %MapSet{},
             mentions: MapSet.new([218_348_062_828_003_328]),
             pinned: false,
             timestamp: "2018-05-01T18:45:57.286000+00:00",
             tts: false,
             type: 0
           }
  end

  test "to_string returns content" do
    stringified =
      %Crux.Structs.Message{content: "hello there!"}
      |> to_string()

    assert stringified == "hello there!"
  end
end
