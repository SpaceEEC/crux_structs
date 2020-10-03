defmodule Crux.Structs.UserTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.User

  test "create" do
    user =
      %{
        "username" => "space",
        "discriminator" => "0001",
        "id" => "218348062828003328",
        "avatar" => "646a356e237350bf8b8dfde15667dfc4"
      }
      |> Crux.Structs.create(Crux.Structs.User)

    assert user == %Crux.Structs.User{
             bot: false,
             system: false,
             username: "space",
             discriminator: "0001",
             id: 218_348_062_828_003_328,
             avatar: "646a356e237350bf8b8dfde15667dfc4"
           }
  end

  test "to_string returns mention" do
    stringified =
      %Crux.Structs.User{id: 218_348_062_828_003_328}
      |> to_string()

    assert stringified == "<@218348062828003328>"
  end
end
