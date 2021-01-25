defmodule Crux.Structs.MessageTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Message

  alias Crux.Structs
  alias Crux.Structs.{Application, Emoji, Member, Message, Reaction, User}

  test "create" do
    message =
      %{
        "activity" => %{
          "type" => 0,
          "party_id" => "interesting_id"
        },
        "application" => %{
          "cover_image" => "b76db81b683527961ee1432c24a02774",
          "description" => "click the circles! to the beat!",
          "icon" => "ea86f6c52576847a7cb81f1c1faa18a3",
          "id" => "367827983903490050",
          "name" => "osu!",
          "primary_sku_id" => "367827983903490050",
          "summary" => "click the circles! to the beat!"
        },
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
        "mention_channels" => [
          %{
            "id" => "278325129692446722",
            "guild_id" => "278325129692446720",
            "name" => "big-news",
            "type" => 5
          }
        ],
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
        "type" => 0,
        "flags" => 2,
        "message_reference" => %{
          "channel_id" => "278325129692446722",
          "guild_id" => "278325129692446720",
          "message_id" => "306588351130107906"
        },
        "reactions" => [
          %{
            "count" => 1,
            "emoji" => %{"id" => "543171949510000650", "name" => "cirBar"},
            "me" => false
          }
        ]
      }
      |> Structs.create(Message)

    assert message == %Message{
             activity: %{
               type: 0,
               party_id: "interesting_id"
             },
             attachments: [],
             application: %Application{
               cover_image: "b76db81b683527961ee1432c24a02774",
               description: "click the circles! to the beat!",
               icon: "ea86f6c52576847a7cb81f1c1faa18a3",
               id: 367_827_983_903_490_050,
               name: "osu!",
               primary_sku_id: 367_827_983_903_490_050,
               summary: "click the circles! to the beat!"
             },
             author: %User{
               bot: false,
               system: false,
               username: "space",
               discriminator: "0001",
               avatar: "646a356e237350bf8b8dfde15667dfc4",
               id: 218_348_062_828_003_328
             },
             member: %Member{
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
             mention_channels: [
               %{
                 id: 278_325_129_692_446_722,
                 guild_id: 278_325_129_692_446_720,
                 name: "big-news",
                 type: 5
               }
             ],
             mention_everyone: false,
             mention_roles: %MapSet{},
             mentions: MapSet.new([218_348_062_828_003_328]),
             pinned: false,
             timestamp: "2018-05-01T18:45:57.286000+00:00",
             tts: false,
             type: 0,
             flags: 2,
             message_reference: %{
               channel_id: 278_325_129_692_446_722,
               guild_id: 278_325_129_692_446_720,
               message_id: 306_588_351_130_107_906
             },
             reactions: %{
               543_171_949_510_000_650 => %Reaction{
                 count: 1,
                 emoji: %Emoji{
                   id: 543_171_949_510_000_650,
                   name: "cirBar",
                   roles: MapSet.new()
                 },
                 me: false
               }
             }
           }
  end

  test "to_string returns content" do
    stringified =
      %Crux.Structs.Message{content: "hello there!"}
      |> to_string()

    assert stringified == "hello there!"
  end
end
