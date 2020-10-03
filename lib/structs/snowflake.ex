defmodule Crux.Structs.Snowflake do
  @moduledoc """
    Custom non discord api struct to help with working with Discord's snowflakes.

    For more information see [Discord Docs](https://discord.com/developers/docs/reference#snowflakes).
  """
  @moduledoc since: "0.2.1"

  alias Crux.Structs.Snowflake
  use Bitwise

  @typedoc """
    A discord `snowflake`, an unsigned 64 bit integer.
  """
  @typedoc since: "0.2.1"
  @type t :: 0..0xFFFF_FFFF_FFFF_FFFF

  @typedoc """
    All valid types that can be resolved into a `t:t/0`.
  """
  @typedoc since: "0.2.1"
  @type resolvable :: String.t() | t()

  @doc """
    Returns `true` if `term` is a `t:t/0`; otherwise returns `false`..
  """
  @doc since: "0.2.1"
  defguard is_snowflake(snowflake)
           when is_integer(snowflake) and snowflake in 0..0xFFFF_FFFF_FFFF_FFFF

  @doc """
  The discord epoch, the first second of 2015 or `1420070400000`.

    ```elixir
  iex> Crux.Structs.Snowflake.discord_epoch()
  1_420_070_400_000

    ```
  """
  @doc since: "0.2.1"
  @spec discord_epoch() :: non_neg_integer()
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
  @doc since: "0.2.1"
  @spec deconstruct(t) :: Snowflake.Parts.t()
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
  @doc since: "0.2.1"
  @spec construct(Snowflake.Parts.t() | Keyword.t()) :: t
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
  @doc since: "0.2.1"
  @spec to_snowflake(t()) :: t()
  @spec to_snowflake(String.t()) :: t() | no_return()
  @spec to_snowflake(nil) :: nil
  def to_snowflake(nil), do: nil

  def to_snowflake(snowflake) when is_snowflake(snowflake) do
    snowflake
  end

  def to_snowflake(string) when is_binary(string) do
    string
    |> String.to_integer()
    |> to_snowflake()
  end

  @doc """
    Converts a `t:String.t/0` to a `t:t/0` while allowing `t:t/0` to pass through.

    Returns `:error` if the provided string is not a `t:t/0`.

    ```elixir
    iex> Crux.Structs.Snowflake.parse("invalid")
    :error

    iex> Crux.Structs.Snowflake.parse(218348062828003328)
    218348062828003328

    # Fallbacks
    iex> Crux.Structs.Snowflake.parse("218348062828003328")
    218348062828003328

    ```

  """
  @doc since: "0.2.1"
  @spec parse(t()) :: t()
  @spec parse(String.t()) :: t() | :error

  def parse(snowflake) when is_snowflake(snowflake) do
    snowflake
  end

  def parse(string) when is_binary(string) do
    case Integer.parse(string) do
      {snowflake, ""} when is_snowflake(snowflake) ->
        snowflake

      _ ->
        :error
    end
  end

  # delegates

  @doc """
    Deconstructs a `t:t/0` to its `t:Crux.Structs.Snowflake.Parts.t/0`.
  """
  @doc since: "0.2.1"
  @spec from_integer(t) :: Snowflake.Parts.t()
  defdelegate from_integer(snowflake), to: Snowflake.Parts, as: :deconstruct

  @doc """
    Constructs a `t:t/0` from its `t:Crux.Structs.Snowflake.Parts.t/0`.
  """
  @doc since: "0.2.1"
  @spec to_integer(Snowflake.Parts.t()) :: t()
  defdelegate to_integer(t), to: Snowflake.Parts, as: :construct
end
