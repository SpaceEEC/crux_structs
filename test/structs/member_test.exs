defmodule Crux.Structs.MemberTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Member

  test "create" do
    member =
      %{
        "nick" => "nick",
        "user" => %{
          "username" => "space",
          "discriminator" => "0001",
          "id" => "218348062828003328",
          "avatar" => "646a356e237350bf8b8dfde15667dfc4"
        },
        "roles" => ["251158405832638465", "373405430589816834"],
        "mute" => false,
        "deaf" => false,
        "joined_at" => "2016-11-02T00:51:21.342000+00:00"
      }
      |> Crux.Structs.create(Crux.Structs.Member)

    assert member == %Crux.Structs.Member{
             nick: "nick",
             user: 218_348_062_828_003_328,
             roles: MapSet.new([251_158_405_832_638_465, 373_405_430_589_816_834]),
             mute: false,
             deaf: false,
             joined_at: "2016-11-02T00:51:21.342000+00:00",
             guild_id: nil
           }
  end

  test "to_string works without nickname" do
    member =
      %Crux.Structs.Member{user: 218_348_062_828_003_328, nick: nil}
      |> to_string()

    assert member == "<@218348062828003328>"
  end

  test "to_string works with nickname" do
    member =
      %Crux.Structs.Member{user: 218_348_062_828_003_328, nick: "weltraum"}
      |> to_string

    assert member == "<@!218348062828003328>"
  end
end
