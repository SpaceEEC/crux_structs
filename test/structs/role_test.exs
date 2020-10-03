defmodule Crux.Structs.RoleTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Role

  alias Crux.Structs.Permissions

  test "create" do
    role =
      %{
        "hoist" => false,
        "name" => "role name",
        "mentionable" => true,
        "color" => 5_533_306,
        "position" => 8,
        "id" => "376146940762783746",
        "managed" => false,
        "permissions" => 3_524_608,
      }
      |> Crux.Structs.create(Crux.Structs.Role)

    assert role == %Crux.Structs.Role{
             id: 376_146_940_762_783_746,
             name: "role name",
             color: 5_533_306,
             hoist: false,
             position: 8,
             permissions: Permissions.new(3_524_608),
             managed: false,
             mentionable: true,
             guild_id: nil
           }
  end

  test "to_string returns mention" do
    stringified =
      %Crux.Structs.Role{id: 376_146_940_762_783_746}
      |> to_string()

    assert stringified == "<@&376146940762783746>"
  end
end
