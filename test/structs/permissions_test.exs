defmodule Crux.Structs.PermissionsTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Permissions

  test "to_map" do
    permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

    Crux.Structs.Permissions.to_map(permissions)
    |> Enum.each(fn {name, value} ->
      assert {name, name in permissions} === {name, value}
    end)
  end

  test "to_list" do
    permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

    assert permissions === Crux.Structs.Permissions.to_list(permissions)
  end
end
