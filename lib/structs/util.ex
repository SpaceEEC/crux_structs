defmodule Crux.Structs.Util do
  @moduledoc """
    Collection of util functions.
  """
  alias Crux.Structs

  @doc """
    Converts a string, likely Discord snowflake, to an integer
  """
  @spec id_to_int(id :: String.t() | integer() | nil) :: integer() | nil | no_return()
  def id_to_int(str) when is_bitstring(str), do: String.to_integer(str)
  def id_to_int(already) when is_integer(already), do: already
  def id_to_int(nil), do: nil

  @doc """
    Converts a list of raw api data to structs keyed under the passed key.
  """
  @spec raw_data_to_map(data :: list, target :: module(), key :: atom()) :: map()
  def raw_data_to_map(data, target, key \\ :id) do
    Structs.create(data, target)
    |> Map.new(fn struct -> {Map.fetch!(struct, key), struct} end)
  end

  @doc """
    Converts a string to an atom.

    Returns an already converted atom as is instead of raising
  """
  @spec string_to_atom(string :: String.t() | atom()) :: atom()
  def string_to_atom(string) when is_bitstring(string), do: String.to_atom(string)
  def string_to_atom(atom) when is_atom(atom), do: atom

  @doc """
    Atomifies all keys in a passed list or map to avoid the mess of mixed string and atom keys the gateway sends.
  """
  @spec atomify(input :: map() | list()) :: map() | list()
  def atomify(input)
  def atomify(%{} = map), do: Map.new(map, &atomify_kv/1)
  def atomify(list) when is_list(list), do: Enum.map(list, &atomify/1)
  def atomify(other), do: other

  defp atomify_kv({k, v}) do
    k = string_to_atom(k)

    v =
      case v do
        list when is_list(list) ->
          atomify(list)

        %{} = map ->
          atomify(map)

        v ->
          v
      end

    {k, v}
  end
end
