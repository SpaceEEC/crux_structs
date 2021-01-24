defmodule Crux.Structs.GuildTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Guild

  alias Crux.Structs
  alias Crux.Structs.{Guild, Member, Role, VoiceState}

  describe "create/1" do
    test "minimal guild" do
      guild =
        %{
          "id" => "243175181885898762",
          "unavailable" => true
        }
        |> Structs.create(Guild)

      assert %Guild{
               id: 243_175_181_885_898_762,
               unavailable: true
             } = guild
    end

    test "simple properties" do
      guild =
        %{
          "widget_channel_id" => nil,
          "system_channel_id" => "243175181885898762",
          "premium_tier" => 0,
          "system_channel_flags" => 0,
          "discovery_splash" => nil,
          "approximate_member_count" => 4,
          "approximate_presence_count" => 2,
          "application_id" => nil,
          "owner_id" => "218348062828003328",
          "banner" => nil,
          "features" => [],
          "id" => "243175181885898762",
          "public_updates_channel_id" => nil,
          "verification_level" => 2,
          "roles" => [
            %{
              "color" => 0,
              "hoist" => false,
              "id" => "243175181885898762",
              "managed" => false,
              "mentionable" => false,
              "name" => "@everyone",
              "permissions" => 0,
              "position" => 0
            }
          ],
          "embed_channel_id" => nil,
          "splash" => nil,
          "afk_timeout" => 300,
          "vanity_url_code" => nil,
          "icon" => "add8c452e1f9821e99b8411360fbfd1d",
          "emojis" => %{},
          "max_video_channel_users" => 25,
          "preferred_locale" => "de",
          "region" => "frankfurt",
          "explicit_content_filter" => 2,
          "rules_channel_id" => nil,
          "default_message_notifications" => 1,
          "name" => "name",
          "max_members" => 250_000,
          "widget_enabled" => false,
          "description" => nil,
          "embed_enabled" => false,
          "premium_subscription_count" => 0,
          "mfa_level" => 0,
          "afk_channel_id" => nil,
          "max_presences" => nil
        }
        |> Structs.create(Guild)

      assert %Guild{
               widget_channel_id: nil,
               system_channel_id: 243_175_181_885_898_762,
               premium_tier: 0,
               system_channel_flags: 0,
               discovery_splash: nil,
               approximate_member_count: 4,
               approximate_presence_count: 2,
               application_id: nil,
               owner_id: 218_348_062_828_003_328,
               banner: nil,
               features: %MapSet{},
               id: 243_175_181_885_898_762,
               public_updates_channel_id: nil,
               verification_level: 2,
               roles: %{
                 243_175_181_885_898_762 => %Role{
                   id: 243_175_181_885_898_762,
                   color: 0,
                   guild_id: 243_175_181_885_898_762,
                   hoist: false,
                   managed: false,
                   mentionable: false,
                   name: "@everyone",
                   permissions: 0,
                   position: 0
                 }
               },
               splash: nil,
               afk_timeout: 300,
               vanity_url_code: nil,
               icon: "add8c452e1f9821e99b8411360fbfd1d",
               emojis: MapSet.new(),
               max_video_channel_users: 25,
               preferred_locale: "de",
               region: "frankfurt",
               explicit_content_filter: 2,
               rules_channel_id: nil,
               default_message_notifications: 1,
               name: "name",
               max_members: 250_000,
               widget_enabled: false,
               description: nil,
               premium_subscription_count: 0,
               mfa_level: 0,
               afk_channel_id: nil,
               max_presences: nil
             } == guild
    end

    test "emojis" do
      guild =
        %{
          "id" => "243175181885898762",
          "emojis" => [
            %{
              "animated" => false,
              "available" => true,
              "id" => "338722955632705546",
              "managed" => false,
              "name" => "DeanEyes",
              "require_colons" => true,
              "roles" => []
            },
            %{
              "animated" => false,
              "available" => true,
              "id" => "340234098767560724",
              "managed" => false,
              "name" => "Missing",
              "require_colons" => true,
              "roles" => []
            }
          ]
        }
        |> Structs.create(Guild)

      emojis = MapSet.new([338_722_955_632_705_546, 340_234_098_767_560_724])

      assert %Guild{
               id: 243_175_181_885_898_762,
               emojis: ^emojis
             } = guild
    end

    test "roles" do
      guild =
        %{
          "id" => "243175181885898762",
          "roles" => [
            %{
              "color" => 0,
              "hoist" => false,
              "id" => "243175181885898762",
              "managed" => false,
              "mentionable" => false,
              "name" => "@everyone",
              "permissions" => 0,
              "position" => 0
            },
            %{
              "color" => 0,
              "hoist" => false,
              "id" => "243175678227382273",
              "managed" => false,
              "mentionable" => false,
              "name" => "perms",
              "permissions" => 2_146_959_351,
              "position" => 5
            }
          ]
        }
        |> Structs.create(Guild)

      roles = %{
        243_175_181_885_898_762 => %Role{
          color: 0,
          hoist: false,
          id: 243_175_181_885_898_762,
          managed: false,
          mentionable: false,
          name: "@everyone",
          permissions: 0,
          position: 0,
          guild_id: 243_175_181_885_898_762
        },
        243_175_678_227_382_273 => %Role{
          color: 0,
          hoist: false,
          id: 243_175_678_227_382_273,
          managed: false,
          mentionable: false,
          name: "perms",
          permissions: 2_146_959_351,
          position: 5,
          guild_id: 243_175_181_885_898_762
        }
      }

      assert %Guild{
               id: 243_175_181_885_898_762,
               roles: ^roles
             } = guild
    end

    test "channels" do
      guild =
        %{
          "id" => "243175181885898762",
          "channels" => [
            %{
              "guild_id" => "243175181885898762",
              "id" => "243175181885898762",
              "last_message_id" => "690187783989493801",
              "last_pin_timestamp" => "2016-11-03T20:26:34.186000+00:00",
              "name" => "reserved",
              "nsfw" => false,
              "parent_id" => "355984291081224202",
              "permission_overwrites" => [
                %{"allow" => 0, "deny" => 2112, "id" => "243175181885898762", "type" => "role"}
              ],
              "position" => 12,
              "rate_limit_per_user" => 0,
              "topic" => "",
              "type" => 0
            },
            %{
              "guild_id" => "243175181885898762",
              "id" => "258305846671441921",
              "last_message_id" => "684753273743212544",
              "name" => "stuff",
              "nsfw" => false,
              "parent_id" => "356021759150915584",
              "permission_overwrites" => [
                %{"allow" => 0, "deny" => 1024, "id" => "243175181885898762", "type" => "role"}
              ],
              "position" => 2,
              "rate_limit_per_user" => 0,
              "topic" => "stuff",
              "type" => 0
            }
          ]
        }
        |> Structs.create(Guild)

      channels = MapSet.new([243_175_181_885_898_762, 258_305_846_671_441_921])

      assert %Guild{
               id: 243_175_181_885_898_762,
               channels: ^channels
             } = guild
    end

    test "members" do
      guild =
        %{
          "id" => "243175181885898762",
          "members" => [
            %{
              "deaf" => false,
              "joined_at" => "2016-11-02T00:51:21.342000+00:00",
              "mute" => false,
              "nick" => nil,
              "premium_since" => nil,
              "roles" => ["243175678227382273", "689090455039770689"],
              "user" => %{
                "avatar" => "646a356e237350bf8b8dfde15667dfc4",
                "discriminator" => "0001",
                "id" => "218348062828003328",
                "public_flags" => 512,
                "username" => "space"
              }
            },
            %{
              "deaf" => false,
              "joined_at" => "2016-11-02T00:52:26.259000+00:00",
              "mute" => false,
              "nick" => "bot",
              "premium_since" => nil,
              "roles" => ["243175678227382273", "266010752794492928", "629736805151014933"],
              "user" => %{
                "avatar" => "ed1a06e91f18a3c0481b282114549e6e",
                "bot" => true,
                "discriminator" => "0234",
                "id" => "242685080693243906",
                "public_flags" => 0,
                "username" => "spacebot"
              }
            }
          ]
        }
        |> Structs.create(Guild)

      members = %{
        218_348_062_828_003_328 => %Member{
          deaf: false,
          joined_at: "2016-11-02T00:51:21.342000+00:00",
          mute: false,
          nick: nil,
          premium_since: nil,
          roles: MapSet.new([243_175_678_227_382_273, 689_090_455_039_770_689]),
          guild_id: 243_175_181_885_898_762,
          user: 218_348_062_828_003_328
        },
        242_685_080_693_243_906 => %Member{
          deaf: false,
          joined_at: "2016-11-02T00:52:26.259000+00:00",
          mute: false,
          nick: "bot",
          premium_since: nil,
          roles:
            MapSet.new([243_175_678_227_382_273, 266_010_752_794_492_928, 629_736_805_151_014_933]),
          guild_id: 243_175_181_885_898_762,
          user: 242_685_080_693_243_906
        }
      }

      # These fail on 1.6 for some reason not clear to me.
      # Whoever fixes this gets a virtual cookie.

      # assert ^members = guild.members

      # assert %Guild{
      #          id: 243_175_181_885_898_762,
      #          members: ^members
      #        } = guild

      # Test this asserting that all members match, one by one then.
      assert map_size(members) == map_size(guild.members)

      for {id, member} <- guild.members do
        expected = members[id]
        assert ^expected = member
      end
    end

    test "voice_states" do
      guild =
        %{
          "id" => "243175181885898762",
          "voice_states" => [
            %{
              channel_id: 629_750_221_437_403_164,
              deaf: false,
              mute: false,
              self_deaf: false,
              self_mute: true,
              self_video: false,
              session_id: "7c00752dce611f89da4ca738a6458c16",
              suppress: false,
              user_id: 218_348_062_828_003_328
            },
            %{
              channel_id: 629_750_221_437_403_164,
              deaf: false,
              mute: false,
              self_deaf: false,
              self_mute: false,
              self_video: false,
              session_id: "7d19d7f3bdb3fe52cc996b81eeb00732",
              suppress: true,
              user_id: 250_381_145_462_538_242
            }
          ]
        }
        |> Structs.create(Guild)

      assert %Guild{
               id: 243_175_181_885_898_762,
               voice_states: %{
                 218_348_062_828_003_328 => %VoiceState{
                   user_id: 218_348_062_828_003_328
                 },
                 250_381_145_462_538_242 => %VoiceState{
                   user_id: 250_381_145_462_538_242
                 }
               }
             } = guild
    end
  end

  test "to_string returns name" do
    stringified =
      %Guild{name: "a cool name"}
      |> to_string()

    assert stringified == "a cool name"
  end
end
