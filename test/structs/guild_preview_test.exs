defmodule Crux.Structs.GuildPreviewTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Guild

  test "create" do
    guild_preview =
      %{
        id: "197038439483310086",
        name: "Discord Testers",
        icon: "f64c482b807da4f539cff778d174971c",
        splash: nil,
        discovery_splash: nil,
        emojis: [
          %{
            name: "name",
            roles: ["197038439483310086"],
            id: "197038439483310086",
            require_colons: true,
            managed: false,
            animated: false,
            available: true
          }
        ],
        features: [
          "DISCOVERABLE",
          "VANITY_URL",
          "ANIMATED_ICON",
          "INVITE_SPLASH",
          "NEWS",
          "PUBLIC",
          "BANNER",
          "VERIFIED",
          "MORE_EMOJI"
        ],
        approximate_member_count: 60814,
        approximate_presence_count: 20034,
        description: "The official place to report Discord Bugs!"
      }
      |> Crux.Structs.create(Crux.Structs.GuildPreview)

    assert guild_preview == %Crux.Structs.GuildPreview{
             id: 197_038_439_483_310_086,
             name: "Discord Testers",
             icon: "f64c482b807da4f539cff778d174971c",
             splash: nil,
             discovery_splash: nil,
             emojis: %{
               197_038_439_483_310_086 => %Crux.Structs.Emoji{
                 name: "name",
                 roles: MapSet.new([197_038_439_483_310_086]),
                 id: 197_038_439_483_310_086,
                 require_colons: true,
                 managed: false,
                 animated: false,
                 available: true
               }
             },
             features:
               MapSet.new([
                 "DISCOVERABLE",
                 "VANITY_URL",
                 "ANIMATED_ICON",
                 "INVITE_SPLASH",
                 "NEWS",
                 "PUBLIC",
                 "BANNER",
                 "VERIFIED",
                 "MORE_EMOJI"
               ]),
             approximate_member_count: 60814,
             approximate_presence_count: 20034,
             description: "The official place to report Discord Bugs!"
           }
  end

  test "to_string returns name" do
    stringified =
      %Crux.Structs.GuildPreview{name: "a cool name"}
      |> to_string()

    assert stringified == "a cool name"
  end
end
