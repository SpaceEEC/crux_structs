defmodule Crux.Structs.PresenceTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Presence

  describe "create/1" do
    test "simple presence" do
      presence =
        %{
          "user" => %{
            "id" => "218348062828003328"
          },
          "activities" => [],
          "status" => "online"
        }
        |> Crux.Structs.create(Crux.Structs.Presence)

      assert presence == %Crux.Structs.Presence{
               user: 218_348_062_828_003_328,
               activities: [],
               status: "online"
             }
    end

    test "custom status in activities" do
      presence =
        %{
          "user" => %{
            "id" => "218348062828003328"
          },
          "status" => "online",
          "activities" => [
            %{
              "type" => 4,
              # What is "type" anyway?
              "name" => "CUSTOM_STATUS",
              "state" => "Some status",
              "emoji" => %{
                "id" => "340234098767560724",
                "name" => "Missing",
                "animated" => false
              }
            }
          ]
        }
        |> Crux.Structs.create(Crux.Structs.Presence)

      assert presence == %Crux.Structs.Presence{
               user: 218_348_062_828_003_328,
               activities: [
                 %{
                   type: 4,
                   name: "CUSTOM_STATUS",
                   state: "Some status",
                   emoji: %Crux.Structs.Emoji{
                     id: 340_234_098_767_560_724,
                     name: "Missing",
                     animated: false,
                     roles: MapSet.new()
                   }
                 }
               ],
               status: "online"
             }
    end

    test "custom status without emoji" do
      presence =
        %{
          "user" => %{
            "id" => "218348062828003328"
          },
          "status" => "online",
          "activities" => [
            %{
              "type" => 4,
              # What is "type" anyway?
              "name" => "CUSTOM_STATUS",
              "state" => "Some status",
              "emoji" => nil
            }
          ]
        }
        |> Crux.Structs.create(Crux.Structs.Presence)

      assert presence == %Crux.Structs.Presence{
               user: 218_348_062_828_003_328,
               activities: [
                 %{
                   type: 4,
                   name: "CUSTOM_STATUS",
                   state: "Some status",
                   emoji: nil
                 }
               ],
               status: "online"
             }
    end

    test "activity of an application" do
      presence =
        %{
          "user" => %{
            "id" => "218348062828003328"
          },
          "status" => "online",
          "activities" => [
            %{
              "type" => 1,
              "name" => "foo",
              "application_id" => "474807795183648809",
              "flags" => 2
            }
          ]
        }
        |> Crux.Structs.create(Crux.Structs.Presence)

      assert presence == %Crux.Structs.Presence{
               user: 218_348_062_828_003_328,
               activities: [
                 %{
                   type: 1,
                   name: "foo",
                   application_id: 474_807_795_183_648_809,
                   flags: 2
                 }
               ],
               status: "online"
             }
    end
  end
end
