defmodule Crux.Structs.BitField do
  @moduledoc """
  Custom non discord api behaviour to help with bitfields of all kind.
  """
  @moduledoc since: "0.2.3"

  @typedoc """
  The name of a bit flag.
  """
  @typedoc since: "0.2.3"
  @type name :: atom()

  @doc """
  Get a map of `t:name/0`s and their corresponding bit values.
  """
  @doc since: "0.2.3"
  @callback flags() :: %{required(name()) => t()}

  @doc """
  Get a list of all available `t:name/0`s.
  """
  @doc since: "0.2.3"
  @callback names() :: [name()]

  @doc """
  Get a bitfield representing all available bits set.
  """
  @doc since: "0.2.3"
  @callback all() :: t()

  @typedoc """
  All valid types that can be directly resolved into a bitfield.
  """
  @typedoc since: "0.2.3"
  @type resolvable() :: t() | non_neg_integer() | String.t() | name() | [resolvable()]

  @typedoc """
  Represents a bitfield of a module implementing the `Crux.Structs.BitField` behaviour.
  """
  @typedoc since: "0.2.3"
  @type t :: non_neg_integer()

  @doc """
  Resolve a `t:resolvable/0` into a bitfield.
  """
  @doc since: "0.2.3"
  @callback resolve(resolvable()) :: t()

  @doc """
  Serialize a `t:resolvable/0` into a map, which is mapping all `t:name/0`s to whether they are set.
  """
  @doc since: "0.2.3"
  @callback to_map(resolvable()) :: %{required(name()) => boolean()}

  @doc """
  Serialize a `t:resolvable/0` into a list of set bit flag names.
  """
  @doc since: "0.2.3"
  @callback to_list(resolvable()) :: [name()]

  @doc """
  Add all set bits of `to_add` to `base`.
  """
  @doc since: "0.2.3"
  @callback add(base :: resolvable(), to_add :: resolvable()) :: t()

  @doc """
  Remove all set bits of `to_remove` from `base`.
  """
  @doc since: "0.2.3"
  @callback remove(base :: resolvable(), to_remove :: resolvable()) :: t()

  @doc """
  Check whether the `t:resolvable/0` you `have` has everything set you `want`.
  """
  @doc since: "0.2.3"
  @callback has(have :: resolvable(), want :: resolvable()) :: boolean()

  @doc """
  Return a `t:t/0` of all bits you `want` but not `have`.
  """
  @doc since: "0.2.3"
  @callback missing(have :: resolvable(), want :: resolvable()) :: t()

  defmacro __using__(flags) do
    quote location: :keep do
      @behaviour Crux.Structs.BitField

      use Bitwise

      @flags unquote(flags)
      @doc """
      Get a map of `t:name/0`s and their corresponding bit values.
      """
      @spec flags() :: %{required(name()) => t()}
      def flags(), do: @flags

      @names Map.keys(@flags)
      @doc """
      Get a list of all available `t:name/0`s.
      """
      @spec names() :: [name()]
      def names(), do: @names

      @all Enum.reduce(@flags, 0, fn {_name, bit}, acc -> bit ||| acc end)
      @doc """
      Get an integer representing all available bits set.
      """
      @spec all() :: t()
      def all(), do: @all

      @typedoc """
      All valid types that can be directly resolved into a bitfield.
      """
      @type resolvable() :: t() | raw() | name() | [resolvable()]

      @type t :: non_neg_integer()

      @typedoc """
      Raw bitfield that can be used as a `t:resolvable/0`.
      """
      @type raw :: non_neg_integer() | String.t()

      @doc """
      Resolve a `t:resolvable/0` into a bitfield.
      """
      @spec resolve(resolvable()) :: t()
      def resolve(resolvable)

      def resolve(resolvable)
          when is_integer(resolvable) and resolvable >= 0 do
        resolvable
      end

      def resolve(resolvable)
          when resolvable in @names do
        Map.get(@flags, resolvable)
      end

      def resolve(resolvable)
          when is_list(resolvable) do
        Enum.reduce(resolvable, 0, &(resolve(&1) ||| &2))
      end

      def resolve(resolvable)
          when is_binary(resolvable) do
        case Integer.parse(resolvable) do
          {bitfield, ""} ->
            resolve(bitfield)

          _ ->
            raise_resolve(resolvable)
        end
      end

      def resolve(resolvable) do
        raise_resolve(resolvable)
      end

      defp raise_resolve(resolvable) do
        raise ArgumentError, """
        Expected a name atom, a non negative integer, or a list of them.

        Received:
        #{inspect(resolvable)}
        """
      end

      @doc """
      Serialize a `t:resolvable/0` into a map representing bit flag names to whether they are set.
      """
      @spec to_map(resolvable()) :: %{required(name()) => boolean()}
      def to_map(resolvable) do
        bitfield = resolve(resolvable)

        Map.new(@names, &{&1, has(bitfield, &1)})
      end

      @doc """
      Serialize a `t:resolvable/0` into a list of set bit flag names.
      """
      @spec to_list(resolvable()) :: [name()]
      def to_list(resolvable) do
        resolvable = resolve(resolvable)

        Enum.reduce(@flags, [], fn {name, val}, acc ->
          if has(resolvable, val), do: [name | acc], else: acc
        end)
      end

      @doc """
      Add all set bits of `to_add` to `base`.
      """
      @spec add(base :: resolvable(), to_add :: resolvable()) :: t()
      def add(base, to_add) do
        to_add = resolve(to_add)

        base
        |> resolve()
        |> bor(to_add)
      end

      @doc """
      Remove all set bits of `to_remove` from `base`.
      """
      @spec remove(base :: resolvable(), to_remove :: resolvable()) :: t()
      def remove(base, to_remove) do
        to_remove = to_remove |> resolve() |> bnot()

        base
        |> resolve()
        |> band(to_remove)
      end

      @doc """
      Check whether the `t:resolvable/0` you `have` has everything set you `want`.
      """
      @spec has(
              have :: resolvable(),
              want :: resolvable()
            ) :: boolean()
      def has(have, want) do
        have = resolve(have)
        want = resolve(want)

        (have &&& want) == want
      end

      @doc """
      Return a `t:t/0` of all bits you `want` but not `have`.
      """
      @spec missing(resolvable(), resolvable()) :: t()
      def missing(have, want) do
        have = resolve(have)
        want = resolve(want)

        want
        |> band(~~~have)
      end
    end
  end
end
