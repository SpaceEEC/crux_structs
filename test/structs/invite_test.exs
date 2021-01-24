defmodule Crux.Structs.InviteTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Invite

  alias Crux.Structs
  alias Crux.Structs.{Channel, Guild, Invite, User}

  describe "create/1" do
    test "/invites/:code" do
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
        |> Structs.create(Invite)

      assert invite == %Invite{
               channel: %Channel{
                 id: 381_898_062_269_775_883,
                 name: "rules",
                 type: 0
               },
               code: "discord-api",
               guild: %Guild{
                 features: MapSet.new(["INVITE_SPLASH", "VANITY_URL", "VIP_REGIONS"]),
                 icon: "a8eccf1628b1e739d535a813f279e905",
                 id: 81_384_788_765_712_384,
                 name: "Discord API",
                 splash: nil,
                 verification_level: 3
               }
             }
    end

    test "/invites/:id?with_counts=true" do
      invite =
        %{
          "code" => "discord-api",
          "guild" => %{
            "id" => "81384788765712384",
            "name" => "Discord API",
            "splash" => nil,
            "banner" => "eb9ca6e176964bd43ee5b098dbbf3a78",
            "description" => nil,
            "icon" => "d3fb5f8de75f22494de95e5c1d47af51",
            "features" => [
              "NEWS",
              "VANITY_URL",
              "PARTNERED",
              "ANIMATED_ICON",
              "BANNER",
              "INVITE_SPLASH",
              "VIP_REGIONS"
            ],
            "verification_level" => 3,
            "vanity_url_code" => "discord-api"
          },
          "channel" => %{"id" => "381898062269775883", "name" => "rules", "type" => 0},
          "approximate_member_count" => 55097,
          "approximate_presence_count" => 23695
        }
        |> Structs.create(Invite)

      assert invite == %Invite{
               channel: %Channel{
                 id: 381_898_062_269_775_883,
                 name: "rules",
                 type: 0
               },
               code: "discord-api",
               guild: %Guild{
                 banner: "eb9ca6e176964bd43ee5b098dbbf3a78",
                 features:
                   MapSet.new([
                     "NEWS",
                     "VANITY_URL",
                     "PARTNERED",
                     "ANIMATED_ICON",
                     "BANNER",
                     "INVITE_SPLASH",
                     "VIP_REGIONS"
                   ]),
                 icon: "d3fb5f8de75f22494de95e5c1d47af51",
                 id: 81_384_788_765_712_384,
                 name: "Discord API",
                 splash: nil,
                 verification_level: 3,
                 vanity_url_code: "discord-api"
               },
               approximate_member_count: 55097,
               approximate_presence_count: 23695
             }
    end

    test "/guilds/:id/invites" do
      invite =
        %{
          "channel" => %{"id" => "243175181885898762", "name" => "reserved", "type" => 0},
          "code" => "some_code",
          "created_at" => "2017-03-26T23:18:17.938000+00:00",
          "guild" => %{
            "banner" => "29c1980a3471cb2d5c1208c5196278fb",
            "description" => nil,
            "features" => [],
            "icon" => "add8c452e1f9821e99b8411360fbfd1d",
            "id" => "243175181885898762",
            "name" => "name",
            "splash" => nil,
            "vanity_url_code" => nil,
            "verification_level" => 2
          },
          "inviter" => %{
            "avatar" => "646a356e237350bf8b8dfde15667dfc4",
            "discriminator" => "0001",
            "id" => "218348062828003328",
            "public_flags" => 512,
            "username" => "space"
          },
          "max_age" => 0,
          "max_uses" => 0,
          "temporary" => false,
          "uses" => 76
        }
        |> Structs.create(Invite)

      assert invite == %Invite{
               channel: %Channel{
                 id: 243_175_181_885_898_762,
                 name: "reserved",
                 type: 0
               },
               code: "some_code",
               created_at: "2017-03-26T23:18:17.938000+00:00",
               guild: %Guild{
                 banner: "29c1980a3471cb2d5c1208c5196278fb",
                 description: nil,
                 icon: "add8c452e1f9821e99b8411360fbfd1d",
                 id: 243_175_181_885_898_762,
                 name: "name",
                 splash: nil,
                 vanity_url_code: nil,
                 verification_level: 2,
                 features: MapSet.new()
               },
               inviter: %User{
                 avatar: "646a356e237350bf8b8dfde15667dfc4",
                 bot: false,
                 system: false,
                 discriminator: "0001",
                 id: 218_348_062_828_003_328,
                 public_flags: 512,
                 username: "space"
               },
               max_age: 0,
               max_uses: 0,
               temporary: false,
               uses: 76
             }
    end
  end
end
