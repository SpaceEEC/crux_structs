defmodule Crux.Structs.WebhookTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Webhook

  alias Crux.Structs
  alias Crux.Structs.Webhook

  describe "create/1" do
    test "minimal webhook" do
      webhook =
        %{
          "id" => "550715604512931840",
          "channel_id" => "550715512577982494"
        }
        |> Structs.create(Webhook)

      assert webhook == %Webhook{
               id: 550_715_604_512_931_840,
               channel_id: 550_715_512_577_982_494
             }
    end

    test "default webhook" do
      webhook =
        %{
          "type" => 1,
          "id" => "550715604512931840",
          "name" => "crux_*",
          "avatar" => nil,
          "channel_id" => "550715512577982494",
          "guild_id" => "516569101267894284",
          "token" => "some_token_here",
          "user" => %{
            "avatar" => "646a356e237350bf8b8dfde15667dfc4",
            "discriminator" => "0001",
            "id" => "218348062828003328",
            "public_flags" => 512,
            "username" => "space"
          }
        }
        |> Structs.create(Webhook)

      assert webhook == %Webhook{
               type: 1,
               id: 550_715_604_512_931_840,
               name: "crux_*",
               avatar: nil,
               channel_id: 550_715_512_577_982_494,
               guild_id: 516_569_101_267_894_284,
               token: "some_token_here",
               user: 218_348_062_828_003_328
             }
    end

    test "follower webhook" do
      webhook =
        %{
          "avatar" => "09347e32e597650a217dafa7f86c738c",
          "channel_id" => "612356602850181161",
          "guild_id" => "243175181885898762",
          "id" => "678636620286656543",
          "name" => "#announcements",
          "type" => 2,
          "user" => %{
            "avatar" => "646a356e237350bf8b8dfde15667dfc4",
            "discriminator" => "0001",
            "id" => "218348062828003328",
            "public_flags" => 512,
            "username" => "space"
          }
        }
        |> Structs.create(Webhook)

      assert webhook == %Webhook{
               type: 2,
               id: 678_636_620_286_656_543,
               name: "#announcements",
               avatar: "09347e32e597650a217dafa7f86c738c",
               channel_id: 612_356_602_850_181_161,
               guild_id: 243_175_181_885_898_762,
               token: nil,
               user: 218_348_062_828_003_328
             }
    end
  end

  test "to_string returns mention" do
    stringified =
      %Webhook{id: 550_715_604_512_931_840}
      |> to_string()

    assert stringified == "<@550715604512931840>"
  end
end
