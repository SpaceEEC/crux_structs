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

    For more information see [Discord Docs](https://discordapp.com/developers/docs/reference#snowflakes).
  """

  use Bitwise

  alias Crux.Structs.{Snowflake, Util}
  require Util

  @discord_epoch 1_420_070_400_000

  @doc false
  @spec discord_epoch() :: non_neg_integer()
  Util.since("0.2.1")
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
  Util.typesince("0.2.1")

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
  @spec deconstruct(Snowflake.t()) :: t
  Util.since("0.2.1")

  def deconstruct(snowflake) when is_integer(snowflake) and snowflake >= 0 do
    %Snowflake.Parts{
      timestamp: ((snowflake &&& @timestamp_bitmask) >>> 22) + @discord_epoch,
      worker_id: (snowflake &&& @worker_id_bitmask) >>> 17,
      process_id: (snowflake &&& @process_id_bitmask) >>> 12,
      increment: snowflake &&& @increment_bitmask
    }
  end

  @doc false
  @spec construct(t | Keyword.t()) :: Snowflake.t()
  Util.since("0.2.1")

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

defmodule Crux.Structs.Snowflake do
  @moduledoc """
    Custom non discord api struct to help with working with Discord's snowflakes.

    For more information see [Discord Docs](https://discordapp.com/developers/docs/reference#snowflakes).
  """

  use Bitwise

  alias Crux.Structs.{Snowflake, Util}
  require Util

  Util.modulesince("0.2.1")

  @typedoc """
    A discord `snowflake`, an unsigned 64 bit integer.
  """
  Util.typesince("0.2.1")
  @type t :: 0..0xFFFF_FFFF_FFFF_FFFF

  @doc """
    Returns `true` if `term` is a `t:t/0`; otherwise returns `false`..
  """
  Util.typesince("0.2.1")

  defguard is_snowflake(snowflake)
           when is_integer(snowflake) and snowflake in 0..0xFFFF_FFFF_FFFF_FFFF

  @doc """
  The discord epoch, the first second of 2015 or `1420070400000`.

    ```elixir
  iex> Crux.Structs.Snowflake.discord_epoch()
  1_420_070_400_000

    ```
  """
  @spec discord_epoch() :: non_neg_integer()
  Util.since("0.2.1")
  defdelegate discord_epoch(), to: Crux.Structs.Snowflake.Parts

  @doc """
    Deconstructs a `t:t/0` to its `t:Crux.Structs.Snowflake.Parts.t/0`.

    ```elixir
  iex> Crux.Structs.Snowflake.deconstruct(218348062828003328)
  %Crux.Structs.Snowflake.Parts{
    increment: 0,
    process_id: 0,
    timestamp: 1472128634889,
    worker_id: 1
  }

    ```
  """
  @spec deconstruct(t) :: Snowflake.Parts.t()
  Util.since("0.2.1")
  defdelegate deconstruct(snowflake), to: Snowflake.Parts

  @doc """
    Constructs a `t:t/0` from its `t:Crux.Structs.Snowflake.Parts.t/0` or a keyword of its fields.

    ```elixir
  iex> %Crux.Structs.Snowflake.Parts{increment: 0, process_id: 0, timestamp: 1472128634889, worker_id: 1}
  ...> |> Crux.Structs.Snowflake.construct()
  218348062828003328

  iex> Crux.Structs.Snowflake.construct(increment: 1, timestamp: 1451106635493)
  130175406673231873

  iex> Crux.Structs.Snowflake.construct(timestamp: Crux.Structs.Snowflake.discord_epoch())
  0

    ```
  """
  @spec construct(Snowflake.Parts.t() | Keyword.t()) :: t
  Util.since("0.2.1")
  defdelegate construct(parts), to: Snowflake.Parts

  @doc """
    Converts a `t:String.t/0` to a `t:t/0` while allowing `t:t/0` and `nil` to pass through.

    Raises an `ArgumentError` if the provided string is not an integer.

    ```elixir
    iex> Crux.Structs.Snowflake.to_snowflake(218348062828003328)
    218348062828003328

    # Fallbacks
    iex> Crux.Structs.Snowflake.to_snowflake("218348062828003328")
    218348062828003328

    iex> Crux.Structs.Snowflake.to_snowflake(nil)
    nil

    ```
  """
  @spec to_snowflake(String.t() | t()) :: t() | no_return()
  @spec to_snowflake(nil) :: nil
  Util.since("0.2.1")
  def to_snowflake(nil), do: nil

  def to_snowflake(snowflake) when is_snowflake(snowflake) do
    snowflake
  end

  def to_snowflake(string) when is_binary(string) do
    string
    |> String.to_integer()
    |> to_snowflake()
  end

  # delegates

  @doc """
    Deconstructs a `t:t/0` to its `t:Crux.Structs.Snowflake.Parts.t/0`.
  """
  @spec from_integer(t) :: Snowflake.Parts.t()
  Util.since("0.2.1")
  defdelegate from_integer(snowflake), to: Snowflake.Parts, as: :deconstruct

  @doc """
    Constructs a `t:t/0` from its `t:Crux.Structs.Snowflake.Parts.t/0`.
  """
  @spec to_integer(Snowflake.Parts.t()) :: t()
  Util.since("0.2.1")
  defdelegate to_integer(t), to: Snowflake.Parts, as: :construct
end
