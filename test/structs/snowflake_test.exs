defmodule Crux.Structs.SnowflakeTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Snowflake

  alias Crux.Structs.Snowflake

  test "from_integer alias works" do
    id = 218_348_062_828_003_328
    assert Snowflake.from_integer(id) === Snowflake.deconstruct(id)
  end

  test "to_integer alias works" do
    snowflake = %Crux.Structs.Snowflake{
      increment: 0,
      process_id: 0,
      timestamp: 1_472_128_634_889,
      worker_id: 1
    }

    assert Snowflake.to_integer(snowflake) === Snowflake.construct(snowflake)
  end

  test "forth and back yields same result (start integer)" do
    id = 218_348_062_828_003_328

    assert id === Snowflake.deconstruct(id) |> Snowflake.construct()
  end

  test "forth and back yields same result (start struct)" do
    snowflake = %Crux.Structs.Snowflake{
      increment: 0,
      process_id: 0,
      timestamp: 1_472_128_634_889,
      worker_id: 1
    }

    assert snowflake === Snowflake.construct(snowflake) |> Snowflake.deconstruct()
  end
end
