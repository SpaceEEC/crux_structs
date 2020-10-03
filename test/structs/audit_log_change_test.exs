defmodule Crux.Structs.AuditLogChangeTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.AuditLogChange

  alias Crux.Structs
  alias Crux.Structs.{AuditLogChange, Overwrite, Permissions, Role}

  describe "create/1" do
    test "add role" do
      change =
        %{
          "key" => "$add",
          "new_value" => [%{"id" => "689090455039770689", "name" => "Kuchen"}]
        }
        |> Structs.create(AuditLogChange)

      assert %AuditLogChange{
               key: "$add",
               old_value: nil,
               new_value: [%Role{id: 689_090_455_039_770_689, name: "Kuchen"}]
             } = change
    end

    test "remove role" do
      change =
        %{
          "key" => "$remove",
          "new_value" => [%{"id" => "689090455039770689", "name" => "Kuchen"}]
        }
        |> Structs.create(AuditLogChange)

      assert %AuditLogChange{
               key: "$remove",
               old_value: nil,
               new_value: [%Role{id: 689_090_455_039_770_689, name: "Kuchen"}]
             } = change
    end

    test "overwrites" do
      change =
        %{
          "key" => "permission_overwrites",
          "new_value" => [
            %{"allow" => 1024, "deny" => 0, "id" => "218348062828003328", "type" => "member"},
            %{"allow" => 2048, "deny" => 0, "id" => "257884228451041280", "type" => "member"}
          ]
        }
        |> Structs.create(AuditLogChange)

      assert %AuditLogChange{
               key: "permission_overwrites",
               old_value: nil,
               new_value: [
                 %Overwrite{
                   allow: Permissions.new(1024),
                   deny: Permissions.new(0),
                   id: 218_348_062_828_003_328,
                   type: "member"
                 },
                 %Overwrite{
                   allow: Permissions.new(2048),
                   deny: Permissions.new(0),
                   id: 257_884_228_451_041_280,
                   type: "member"
                 }
               ]
             } == change
    end
  end
end
