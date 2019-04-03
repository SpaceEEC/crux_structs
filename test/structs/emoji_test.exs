defmodule Crux.Structs.EmojiTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Emoji

  test "create a unicode emoji" do
    emoji =
      %{"animated" => false, "id" => nil, "name" => "👋"}
      |> Crux.Structs.create(Crux.Structs.Emoji)

    assert emoji == %Crux.Structs.Emoji{
             animated: false,
             id: nil,
             name: "👋",
             roles: MapSet.new(),
             user: nil,
             require_colons: nil,
             managed: nil
           }
  end

  test "a custom emoji" do
    emoji =
      %{
        "managed" => false,
        "name" => "Missing",
        "roles" => [],
        "user" => %{
          "username" => "space",
          "discriminator" => "0001",
          "id" => "218348062828003328",
          "avatar" => "646a356e237350bf8b8dfde15667dfc42"
        },
        "require_colons" => true,
        "animated" => false,
        "id" => "340234098767560724"
      }
      |> Crux.Structs.create(Crux.Structs.Emoji)

    assert emoji == %Crux.Structs.Emoji{
             animated: false,
             id: 340_234_098_767_560_724,
             name: "Missing",
             roles: MapSet.new(),
             user: 218_348_062_828_003_328,
             require_colons: true,
             managed: false
           }
  end
end
