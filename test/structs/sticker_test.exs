defmodule Crux.Crux.StickerTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Sticker

  test "create/1" do
    sticker =
      %{
        "id" => "755244649655959615",
        "name" => "Affection",
        "description" => "Wumpus's helmet featuring a heart emote",
        "pack_id" => "755240383084232756",
        "asset" => "7bf9a060c3eb368992c3ae068faa551a",
        "preview_asset" => nil,
        "format_type" => 3,
        "tags" => "wumpus, affection, hug, cuddle, nuzzle, snuggle, ❤️, heart, :heart"
      }
      |> Crux.Structs.create(Crux.Structs.Sticker)

    assert sticker === %Crux.Structs.Sticker{
             id: 755_244_649_655_959_615,
             name: "Affection",
             description: "Wumpus's helmet featuring a heart emote",
             pack_id: 755_240_383_084_232_756,
             asset: "7bf9a060c3eb368992c3ae068faa551a",
             preview_asset: nil,
             format_type: 3,
             tags: "wumpus, affection, hug, cuddle, nuzzle, snuggle, ❤️, heart, :heart"
           }
  end
end
