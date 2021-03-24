defmodule Crux.Structs.Snowflake.Parts do
  @moduledoc """
  Custom non discord api struct representing a deconstructed Discord snowflake.

  ## Structure of the Parts

  | Field               | Bits     | Number of Bits | Description                                                                |
  | :-----------------: | :------: | :------------: | :------------------------------------------------------------------------: |
  | Timestamp           | 63 to 22 | 42 bits        | Milliseconds since Discord Epoch (1420070400000)                           |
  | Internal Worker ID  | 21 to 17 |  5 bits        |                                                                            |
  | Internal Process ID | 16 to 12 |  5 bits        |                                                                            |
  | Increment           | 11 to  0 | 12 bits        | For every ID that is generated on that process, this number is incremented |

  For more information see [Discord Docs](https://discord.com/developers/docs/reference#snowflakes).
  """
  @moduledoc since: "0.2.1"

  alias Crux.Structs.Snowflake
  use Bitwise

  @discord_epoch 1_420_070_400_000

  @doc false
  @doc since: "0.2.1"
  @spec discord_epoch() :: non_neg_integer()
  def discord_epoch(), do: @discord_epoch

  # bits 63 to 22
  @timestamp_bitmask 0xFFFF_FFFF_FFC0_0000
  # bits 21 to 17
  @worker_id_bitmask 0x3E_0000
  # bits 16 to 12
  @process_id_bitmask 0x1_F000
  # bits 11 to 0
  @increment_bitmask 0xFFF

  @typedoc """
  The parts of a `t:Crux.Structs.Snowflake.t/0`.
  """
  @typedoc since: "0.2.1"
  @type t :: %Snowflake.Parts{
          timestamp: non_neg_integer,
          worker_id: non_neg_integer,
          process_id: non_neg_integer,
          increment: non_neg_integer
        }

  defstruct timestamp: @discord_epoch,
            worker_id: 0,
            process_id: 0,
            increment: 0

  @doc false
  @doc since: "0.2.1"
  @spec deconstruct(Snowflake.t()) :: t
  def deconstruct(snowflake) when is_integer(snowflake) and snowflake >= 0 do
    %Snowflake.Parts{
      timestamp: ((snowflake &&& @timestamp_bitmask) >>> 22) + @discord_epoch,
      worker_id: (snowflake &&& @worker_id_bitmask) >>> 17,
      process_id: (snowflake &&& @process_id_bitmask) >>> 12,
      increment: snowflake &&& @increment_bitmask >>> 0
    }
  end

  @doc false
  @doc since: "0.2.1"
  @spec construct(t | Keyword.t()) :: Snowflake.t()
  def construct(%Snowflake.Parts{
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
    Snowflake.Parts
    |> struct(opts)
    |> construct()
  end
end
