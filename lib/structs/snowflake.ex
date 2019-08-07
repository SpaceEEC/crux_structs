defmodule Crux.Structs.Snowflake do
  @moduledoc """
    Custom non discord api struct to help with working with snowflakes (IDs).

    For more information see [Discord Docs](https://discordapp.com/developers/docs/reference#snowflakes).
  """

  defstruct timestamp: 0,
            worker_id: 0,
            process_id: 0,
            increment: 0

  use Bitwise

  alias Crux.Structs.{Snowflake, Util}
  require Util

  Util.modulesince("0.2.1")

  @discord_epoch 1_420_070_400_000

  # bits 63 to 22
  @timestamp_bitmask 0xFFFFFFFFFFC00000
  # bits 21 to 17
  @worker_id_bitmask 0x3E0000
  # bits 16 to 12
  @process_id_bitmask 0x1F000
  # bits 11 to 0
  @increment_bitmask 0xFFF

  @typedoc """
    A discord `t:snowflake/0`.
  """
  Util.typesince("0.2.1")
  @type snowflake :: non_neg_integer

  @typedoc """
    The parts of a `t:snowflake/0`.
  """
  Util.typesince("0.2.1")

  @type parts :: %Snowflake{
          timestamp: non_neg_integer,
          worker_id: non_neg_integer,
          process_id: non_neg_integer,
          increment: non_neg_integer
        }

  @doc """
  The discord epoch, the first second of 2015 or `1420070400000`.

    ```elixir
  iex> Crux.Structs.Snowflake.discord_epoch()
  #{@discord_epoch}

    ```
  """
  @spec discord_epoch() :: non_neg_integer()
  Util.since("0.2.1")
  def discord_epoch(), do: @discord_epoch

  @doc """
    Deconstructs a `t:snowflake/0` to its `t:parts/0`.

    ```elixir
  iex> Crux.Structs.Snowflake.deconstruct(218348062828003328)
  %Crux.Structs.Snowflake{
    increment: 0,
    process_id: 0,
    timestamp: 1472128634889,
    worker_id: 1
  }

    ```
  """
  @spec deconstruct(snowflake) :: parts
  Util.since("0.2.1")

  def deconstruct(snowflake) when is_integer(snowflake) and snowflake >= 0 do
    %Snowflake{
      timestamp: ((snowflake &&& @timestamp_bitmask) >>> 22) + @discord_epoch,
      worker_id: (snowflake &&& @worker_id_bitmask) >>> 17,
      process_id: (snowflake &&& @process_id_bitmask) >>> 12,
      increment: snowflake &&& @increment_bitmask
    }
  end

  @doc """
    Constructs a `t:snowflake/0` from its `t:parts/0` or a keyword of its fields.

    ```elixir
  iex> %Crux.Structs.Snowflake{increment: 0, process_id: 0, timestamp: 1472128634889, worker_id: 1}
  ...> |> Crux.Structs.Snowflake.construct()
  218348062828003328

  iex> Crux.Structs.Snowflake.construct(increment: 1, timestamp: 1451106635493)
  130175406673231873

  iex> Crux.Structs.Snowflake.construct(timestamp: Crux.Structs.Snowflake.discord_epoch())
  0

    ```
  """
  @spec construct(parts | Keyword.t()) :: snowflake
  Util.since("0.2.1")

  def construct(%Snowflake{
        timestamp: timestamp,
        worker_id: worker_id,
        process_id: process_id,
        increment: increment
      })
      when timestamp >= @discord_epoch and worker_id >= 0 and process_id >= 0 and increment >= 0 do
    timestamp = timestamp - @discord_epoch

    0
    |> bor(timestamp <<< 22 &&& @timestamp_bitmask)
    |> bor(worker_id <<< 17 &&& @worker_id_bitmask)
    |> bor(process_id <<< 12 &&& @process_id_bitmask)
    |> bor(increment <<< 0 &&& @increment_bitmask)
  end

  def construct(opts) when is_list(opts) do
    Snowflake
    |> struct(opts)
    |> construct()
  end

  # delegates

  @doc """
    Deconstructs a `t:snowflake/0` to its `t:parts/0`.
  """
  @spec from_integer(snowflake) :: parts
  Util.since("0.2.1")
  defdelegate from_integer(snowflake), to: Snowflake, as: :deconstruct

  @doc """
    Constructs a `t:snowflake/0` from its `t:parts/0`.
  """
  @spec to_integer(parts) :: snowflake()
  Util.since("0.2.1")
  defdelegate to_integer(t), to: Snowflake, as: :construct
end
