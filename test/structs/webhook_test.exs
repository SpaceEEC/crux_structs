defmodule Crux.Structs.WebhookTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Webhook

  alias Crux.Structs.Webhook

  test "to_string returns mention" do
    stringified =
      %Webhook{id: 550_715_604_512_931_840}
      |> to_string()

    assert stringified == "<@550715604512931840>"
  end
end
