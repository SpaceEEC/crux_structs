defmodule Crux.Structs.EmojiTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Emoji

  alias Crux.Structs
  alias Crux.Structs.Emoji

  test "create a unicode emoji" do
    emoji =
      %{"animated" => false, "id" => nil, "name" => "👋"}
      |> Structs.create(Emoji)

    assert emoji == %Emoji{
             animated: false,
             available: nil,
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
        "available" => true,
        "id" => "340234098767560724"
      }
      |> Structs.create(Emoji)

    assert emoji == %Emoji{
             animated: false,
             available: true,
             id: 340_234_098_767_560_724,
             name: "Missing",
             roles: MapSet.new(),
             user: 218_348_062_828_003_328,
             require_colons: true,
             managed: false
           }
  end

  describe "String.Chars protocol" do
    test "default emoji" do
      emoji =
        %Emoji{
          id: nil,
          name: "👏"
        }
        |> to_string()

      assert "👏" == emoji
    end

    test "animated emoji" do
      emoji =
        %Emoji{
          animated: true,
          id: 393649411961520128,
          name: "youdied"
        }
        |> to_string()

      assert "<a:youdied:393649411961520128>" == emoji
    end

    test "non-animated emoji" do
      emoji =
        %Emoji{
          animated: false,
          id: 367379627984945153,
          name: "QuestionMark"
        }
        |> to_string()

      assert "<:QuestionMark:367379627984945153>" == emoji
    end
  end
end
