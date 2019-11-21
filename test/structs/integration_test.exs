defmodule Crux.Structs.IntegrationTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Integration

  test "create" do
    # Never seen a real integration object, this is just one reconstructed from the docs
    integration =
      %{
        "id" => "647006042328268800",
        "name" => "TestName",
        "type" => "youtube",
        "enabled" => true,
        "syncing" => true,
        "role_id" => "647006142660214785",
        "expire_behavior" => 0,
        "expire_grace_period" => 0,
        "user" => %{
          "avatar" => "646a356e237350bf8b8dfde15667dfc4",
          "discriminator" => "0001",
          "id" => "218348062828003328",
          "username" => "space"
        },
        "account" => %{
          "id" => "647006500681809922",
          "name" => "AccountName"
        },
        "synced_at" => "ISO8601 timestamp"
      }
      |> Crux.Structs.create(Crux.Structs.Integration)

    assert integration == %Crux.Structs.Integration{
             id: 647_006_042_328_268_800,
             name: "TestName",
             type: "youtube",
             enabled: true,
             syncing: true,
             role_id: 647_006_142_660_214_785,
             expire_behavior: 0,
             expire_grace_period: 0,
             user: 218_348_062_828_003_328,
             account: %{
               id: 647_006_500_681_809_922,
               name: "AccountName"
             },
             synced_at: "ISO8601 timestamp"
           }
  end
end
