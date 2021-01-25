defmodule Crux.Structs.RoleTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Role

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
        "permissions" => 3_524_608
      }
      |> Crux.Structs.create(Crux.Structs.Role)

    assert role == %Crux.Structs.Role{
             id: 376_146_940_762_783_746,
             name: "role name",
             color: 5_533_306,
             hoist: false,
             position: 8,
             permissions: 3_524_608,
             managed: false,
             mentionable: true,
             guild_id: nil
           }
  end

  describe "tags" do
    test "premium_subscriber" do
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
          "tags" => %{"premium_subscriber" => nil}
        }
        |> Crux.Structs.create(Crux.Structs.Role)

      assert role == %Crux.Structs.Role{
               id: 376_146_940_762_783_746,
               name: "role name",
               color: 5_533_306,
               hoist: false,
               position: 8,
               permissions: 3_524_608,
               managed: false,
               mentionable: true,
               guild_id: nil,
               tags: %{premium_subscriber: nil}
             }
    end

    test "integration_id" do
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
          "tags" => %{"integration_id" => "376146940762783746"}
        }
        |> Crux.Structs.create(Crux.Structs.Role)

      assert role == %Crux.Structs.Role{
               id: 376_146_940_762_783_746,
               name: "role name",
               color: 5_533_306,
               hoist: false,
               position: 8,
               permissions: 3_524_608,
               managed: false,
               mentionable: true,
               guild_id: nil,
               tags: %{integration_id: 376_146_940_762_783_746}
             }
    end

    test "bot_id" do
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
          "tags" => %{"bot_id" => "376146940762783746"}
        }
        |> Crux.Structs.create(Crux.Structs.Role)

      assert role == %Crux.Structs.Role{
               id: 376_146_940_762_783_746,
               name: "role name",
               color: 5_533_306,
               hoist: false,
               position: 8,
               permissions: 3_524_608,
               managed: false,
               mentionable: true,
               guild_id: nil,
               tags: %{bot_id: 376_146_940_762_783_746}
             }
    end
  end

  test "to_string returns mention" do
    stringified =
      %Crux.Structs.Role{id: 376_146_940_762_783_746}
      |> to_string()

    assert stringified == "<@&376146940762783746>"
  end
end
