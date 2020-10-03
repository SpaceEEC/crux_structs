defmodule Crux.Structs.Util do
  @moduledoc """
    Collection of util functions.
  """
  @moduledoc since: "0.1.0"

  alias Crux.Structs
  alias Crux.Structs.Snowflake

  @doc ~S"""
    Converts a list of raw api data to structs keyed under the passed key.

  ## Examples

    ```elixir
  iex> [
  ...> %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"},
  ...> %{"username" => "Drahcirius", "discriminator" => "1336", "id" => "130175406673231873", "avatar" => "c896aebec82c90f590b08cfebcdc4e3b"}
  ...> ]
  ...> |> Crux.Structs.Util.raw_data_to_map(Crux.Structs.User)
  %{
    130175406673231873 => %Crux.Structs.User{
      username: "Drahcirius",
      discriminator: "1336",
      id: 130175406673231873,
      avatar: "c896aebec82c90f590b08cfebcdc4e3b",
      bot: false,
      system: false
    },
    218348062828003328 => %Crux.Structs.User{
      username: "space",
      discriminator: "0001",
      id: 218348062828003328,
      avatar: "46a356e237350bf8b8dfde15667dfc4",
      bot: false,
      system: false
    }
  }

  iex> [
  ...> %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"},
  ...> %{"username" => "Drahcirius", "discriminator" => "1336", "id" => "130175406673231873", "avatar" => "c896aebec82c90f590b08cfebcdc4e3b"}
  ...> ]
  ...> |> Crux.Structs.Util.raw_data_to_map(Crux.Structs.User, :username)
  %{
    "Drahcirius" => %Crux.Structs.User{
      username: "Drahcirius",
      discriminator: "1336",
      id: 130175406673231873,
      avatar: "c896aebec82c90f590b08cfebcdc4e3b",
      bot: false,
      system: false
    },
    "space" => %Crux.Structs.User{
      username: "space",
      discriminator: "0001",
      id: 218348062828003328,
      avatar: "46a356e237350bf8b8dfde15667dfc4",
      bot: false,
      system: false
    }
  }

    ```

  """
  @doc since: "0.1.0"
  @spec raw_data_to_map(data :: list, target :: module(), key :: atom()) :: map()
  def raw_data_to_map(data, target, key \\ :id) do
    data
    |> Structs.create(target)
    |> Map.new(fn struct -> {Map.fetch!(struct, key), struct} end)
  end

  @doc ~S"""
    Returns a function converting a passed map to an id, using the specified key as key.

  ## Examples

    ```elixir
  # Id is already a number
  iex> Crux.Structs.Util.map_to_id(:foo).(%{foo: 123})
  123

  # Id is a string
  iex> Crux.Structs.Util.map_to_id(:foo).(%{foo: "123"})
  123

  # No id exists
  iex> Crux.Structs.Util.map_to_id(:foo).(%{"foo" => "123"})
  nil

  # Example using `Enum.map/2`
  iex> [
  ...> %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"},
  ...> %{"username" => "Drahcirius", "discriminator" => "1336", "id" => "130175406673231873", "avatar" => "c896aebec82c90f590b08cfebcdc4e3b"}
  ...> ]
  ...> |> Enum.map(Crux.Structs.Util.map_to_id("id"))
  [218348062828003328, 130175406673231873]

    ```
  """
  @doc since: "0.2.0"
  @spec map_to_id(key :: term()) :: (map() -> Snowflake.t() | nil)
  def map_to_id(key \\ :id) do
    fn
      %{^key => value} -> Snowflake.to_snowflake(value)
      _ -> nil
    end
  end

  @doc ~S"""
    Atomifies all keys in a passed list or map to avoid the mess of mixed string and atom keys the gateway sends.

  ## Examples

    ```elixir
  # A map
  iex> %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"}
  ...> |> Crux.Structs.Util.atomify()
  %{username: "space", discriminator: "0001", id: "218348062828003328", avatar: "46a356e237350bf8b8dfde15667dfc4"}

  # A list
  iex> [
  ...>   %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"},
  ...>   %{"username" => "Drahcirius", "discriminator" => "1336", "id" => "130175406673231873", "avatar" => "c896aebec82c90f590b08cfebcdc4e3b"}
  ...> ]
  ...> |> Crux.Structs.Util.atomify()
  [
    %{username: "space", discriminator: "0001", id: "218348062828003328", avatar: "46a356e237350bf8b8dfde15667dfc4"},
    %{username: "Drahcirius", discriminator: "1336", id: "130175406673231873", avatar: "c896aebec82c90f590b08cfebcdc4e3b"}
  ]

  # A nested map
  iex> %{"foo" => "bar", "bar" => %{"baz" => "foo"}}
  ...> |> Crux.Structs.Util.atomify()
  %{foo: "bar", bar: %{baz: "foo"}}

  # A nested list
  iex> [[%{"foo" => "bar"}], %{"bar" => "foo"}]
  ...> |> Crux.Structs.Util.atomify()
  [[%{foo: "bar"}], %{bar: "foo"}]

  # A struct
  iex> %Crux.Structs.Overwrite{id: 448394877194076161, type: "role", allow: 0, deny: 0}
  ...> |> Crux.Structs.Util.atomify()
  %{id: 448394877194076161, type: "role", allow: 0, deny: 0}

    ```
  """
  @doc since: "0.1.0"
  @spec atomify(input :: map() | list()) :: map() | list()
  def atomify(input)
  def atomify(%{__struct__: _struct} = struct), do: struct |> Map.from_struct() |> atomify()
  def atomify(%{} = map), do: Map.new(map, &atomify_kv/1)
  def atomify(list) when is_list(list), do: Enum.map(list, &atomify/1)
  def atomify(other), do: other

  defp atomify_kv({k, v}) when is_atom(k), do: {k, atomify(v)}
  defp atomify_kv({k, v}), do: {String.to_atom(k), atomify(v)}
end
