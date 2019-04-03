defmodule Crux.Structs.ReactionTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Reaction

  test "reaction" do
    reaction =
      %{
        "count" => 5,
        "me" => false,
        "emoji" => %{"animated" => false, "id" => nil, "name" => "👋"}
      }
      |> Crux.Structs.create(Crux.Structs.Reaction)

    assert reaction === %Crux.Structs.Reaction{
             count: 5,
             me: false,
             emoji: %Crux.Structs.Emoji{
               animated: false,
               id: nil,
               name: "👋",
               roles: %MapSet{}
             }
           }
  end
end
