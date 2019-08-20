defmodule Crux.Structs.GuildTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Guild

  test "to_string returns name" do
    stringified =
      %Crux.Structs.Guild{name: "a cool name"}
      |> to_string()

    assert stringified == "a cool name"
  end
end
