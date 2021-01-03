defmodule Crux.Structs.TemplateTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Template

  test "create" do
    template =
      %{
        "code" => "some code",
        "name" => "template name",
        "description" => "template description",
        "usage_count" => 0,
        "creator_id" => "218348062828003328",
        "creator" => %{
          "id" => "218348062828003328",
          "username" => "space",
          "avatar" => "646a356e237350bf8b8dfde15667dfc4",
          "discriminator" => "0001",
          "public_flags" => 131_584
        },
        "created_at" => "2021-01-03T19:23:08+00:00",
        "updated_at" => "2021-01-03T19:34:10+00:00",
        "source_guild_id" => "260850209699921931",
        "serialized_source_guild" => %{
          "name" => "Amsterdam",
          "description" => nil,
          "region" => "amsterdam",
          "icon_hash" => nil,
          "verification_level" => 0,
          "default_message_notifications" => 0,
          "explicit_content_filter" => 0,
          "preferred_locale" => "en-US",
          "afk_timeout" => 300,
          "roles" => [
            %{
              "id" => 0,
              "name" => "@everyone",
              "color" => 0,
              "hoist" => false,
              "mentionable" => false,
              "permissions" => "104324680"
            }
          ],
          "channels" => [
            %{
              "id" => 1,
              "type" => 0,
              "name" => "general",
              "position" => 0,
              "topic" => nil,
              "bitrate" => 64000,
              "user_limit" => 0,
              "nsfw" => false,
              "rate_limit_per_user" => 0,
              "parent_id" => nil,
              "permission_overwrites" => []
            },
            %{
              "id" => 2,
              "type" => 2,
              "name" => "General",
              "position" => 0,
              "topic" => nil,
              "bitrate" => 64000,
              "user_limit" => 0,
              "nsfw" => false,
              "rate_limit_per_user" => 0,
              "parent_id" => nil,
              "permission_overwrites" => []
            }
          ],
          "afk_channel_id" => nil,
          "system_channel_id" => nil,
          "system_channel_flags" => 0
        },
        "is_dirty" => nil
      }
      |> Crux.Structs.create(Crux.Structs.Template)

    assert %Crux.Structs.Template{
             code: "some code",
             name: "template name",
             description: "template description",
             usage_count: 0,
             creator_id: 218_348_062_828_003_328,
             creator: %Crux.Structs.User{id: 218_348_062_828_003_328},
             created_at: "2021-01-03T19:23:08+00:00",
             updated_at: "2021-01-03T19:34:10+00:00",
             source_guild_id: 260_850_209_699_921_931,
             serialized_source_guild: %{},
             is_dirty: nil
           } = template
  end
end
