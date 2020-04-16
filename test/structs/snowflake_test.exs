defmodule Crux.Structs.SnowflakeTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Snowflake

  alias Crux.Structs.Snowflake

  test "from_integer alias works" do
    id = 218_348_062_828_003_328
    assert Snowflake.from_integer(id) === Snowflake.deconstruct(id)
  end

  test "to_integer alias works" do
    snowflake = %Crux.Structs.Snowflake.Parts{
      increment: 0,
      process_id: 0,
      timestamp: 1_472_128_634_889,
      worker_id: 1
    }

    assert Snowflake.to_integer(snowflake) === Snowflake.construct(snowflake)
  end

  test "forth and back yields same result (start integer)" do
    id = 218_348_062_828_003_328

    assert id === id |> Snowflake.deconstruct() |> Snowflake.construct()
  end

  test "forth and back yields same result (start struct)" do
    snowflake = %Crux.Structs.Snowflake.Parts{
      increment: 0,
      process_id: 0,
      timestamp: 1_472_128_634_889,
      worker_id: 1
    }

    assert snowflake === snowflake |> Snowflake.construct() |> Snowflake.deconstruct()
  end

  describe "is_snowflake/1 guard" do
    require Snowflake

    test "too small integer" do
      refute Snowflake.is_snowflake(-1)
    end

    test "too large integer" do
      refute Snowflake.is_snowflake(0x1_0000_0000_0000_0000)
    end

    test "float" do
      refute Snowflake.is_snowflake(1.0)
    end

    test "string" do
      refute Snowflake.is_snowflake("218348062828003328")
    end

    test "snowflake" do
      assert Snowflake.is_snowflake(218_348_062_828_003_328)
    end
  end
end
