defmodule Crux.Structs.OverwriteTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Overwrite

  alias Crux.Structs.Permissions

  test "create" do
    overwrite =
      %{
        "type" => "member",
        "id" => "218348062828003328",
        "allow" => 0x400,
        "deny" => 0x800
      }
      |> Crux.Structs.create(Crux.Structs.Overwrite)

    assert overwrite == %Crux.Structs.Overwrite{
             type: "member",
             id: 218_348_062_828_003_328,
             allow: Permissions.new(0x400),
             deny: Permissions.new(0x800)
           }
  end
end
