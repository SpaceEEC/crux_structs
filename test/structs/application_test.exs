defmodule Crux.Structs.ApplicationTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Application

  describe "create/1" do
    test "with team" do
      application =
        %{
          "id" => "218348062828003328",
          "owner" => %{
            "id" => "218348062828003328",
            "username" => "username",
            "avatar" => nil,
            "discriminator" => "0000",
            "public_flags" => "1024",
            "flags" => "1024"
          },
          "team" => %{
            "id" => "218348062828003328",
            "icon" => nil,
            "owner_user_id" => "218348062828003328",
            "members" => [
              %{
                "membership_state" => 2,
                "permissions" => ["*"],
                "team_id" => "218348062828003328",
                "user" => %{
                  "id" => "218348062828003328"
                }
              }
            ]
          }
        }
        |> Crux.Structs.create(Crux.Structs.Application)

      assert application === %Crux.Structs.Application{
               id: 218_348_062_828_003_328,
               owner: %Crux.Structs.User{
                 id: 218_348_062_828_003_328,
                 username: "username",
                 avatar: nil,
                 discriminator: "0000",
                 public_flags: 1024,
                 bot: false,
                 system: false
               },
               team: %{
                 id: 218_348_062_828_003_328,
                 icon: nil,
                 owner_user_id: 218_348_062_828_003_328,
                 members: %{
                   218_348_062_828_003_328 => %{
                     membership_state: 2,
                     permissions: ["*"],
                     team_id: 218_348_062_828_003_328,
                     user: %Crux.Structs.User{
                       id: 218_348_062_828_003_328,
                       bot: false,
                       system: false
                     }
                   }
                 }
               }
             }
    end

    test "without team" do
      application =
        %{
          "id" => "218348062828003328",
          "owner" => %{
            "id" => "218348062828003328",
            "username" => "username",
            "avatar" => nil,
            "discriminator" => "0000",
            "public_flags" => "1024",
            "flags" => "1024"
          },
          "team" => nil
        }
        |> Crux.Structs.create(Crux.Structs.Application)

      assert application === %Crux.Structs.Application{
               id: 218_348_062_828_003_328,
               owner: %Crux.Structs.User{
                 id: 218_348_062_828_003_328,
                 username: "username",
                 avatar: nil,
                 discriminator: "0000",
                 public_flags: 1024,
                 bot: false,
                 system: false
               },
               team: nil
             }
    end
  end
end
