defmodule Crux.Structs.Util do
  @moduledoc """
    Collection of util functions.
  """

  alias Crux.Structs

  if Version.compare(System.version(), "1.7.0") != :lt do
    @moduledoc since: "0.1.0"
  end

  @doc ~s"""
    Converts a string, likely Discord snowflake, to not negative integer

  ## Examples

    ```elixir
  # A string
  iex> "218348062828003328" |> Crux.Structs.Util.id_to_int()
  218348062828003328

  # Already a number
  iex> 218348062828003328 |> Crux.Structs.Util.id_to_int()
  218348062828003328

  # Fallback
  iex> nil |> Crux.Structs.Util.id_to_int()
  nil

    ```
  """
  @spec id_to_int(id :: String.t() | integer() | nil) :: integer() | nil | no_return()
  if Version.compare(System.version(), "1.7.0") != :lt do
    @doc since: "0.1.0"
  else
    @since "0.1.0"
  end

  @deprecated "Use Snowflake.to_snowflake/1 instead"
  def id_to_int(str) when is_bitstring(str), do: str |> String.to_integer() |> id_to_int
  def id_to_int(already) when is_integer(already) and already >= 0, do: already
  def id_to_int(nil), do: nil

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
      avatar: "c896aebec82c90f590b08cfebcdc4e3b"
    },
    218348062828003328 => %Crux.Structs.User{
      username: "space",
      discriminator: "0001",
      id: 218348062828003328,
      avatar: "46a356e237350bf8b8dfde15667dfc4"
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
      avatar: "c896aebec82c90f590b08cfebcdc4e3b"
    },
    "space" => %Crux.Structs.User{
      username: "space",
      discriminator: "0001",
      id: 218348062828003328,
      avatar: "46a356e237350bf8b8dfde15667dfc4"
    }
  }

    ```

  """
  @spec raw_data_to_map(data :: list, target :: module(), key :: atom()) :: map()
  if Version.compare(System.version(), "1.7.0") != :lt do
    @doc since: "0.1.0"
  else
    @since "0.1.0"
  end

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
  @spec map_to_id(key :: term()) :: (map() -> Snowflake.t() | nil)
  def map_to_id(key \\ :id) do
    fn
      %{^key => value} -> id_to_int(value)
      _ -> nil
    end
  end

  @doc ~S"""
    Converts a string to an atom.

    Returns an already converted atom as is instead of raising

  ## Examples

    ```elixir
  # A string
  iex> "id" |> Crux.Structs.Util.string_to_atom()
  :id

  # Already an atom
  iex> :id |> Crux.Structs.Util.string_to_atom()
  :id

    ```
  """
  @spec string_to_atom(input :: String.t() | atom()) :: atom()
  if Version.compare(System.version(), "1.7.0") != :lt do
    @doc since: "0.1.0"
  else
    @since "0.1.0"
  end

  @deprecated "There will be no replacement"
  def string_to_atom(string) when is_bitstring(string), do: String.to_atom(string)
  def string_to_atom(atom) when is_atom(atom), do: atom

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
  @spec atomify(input :: map() | list()) :: map() | list()
  if Version.compare(System.version(), "1.7.0") != :lt do
    @doc since: "0.1.0"
  else
    @since "0.1.0"
  end

  def atomify(input)
  def atomify(%{__struct__: _struct} = struct), do: struct |> Map.from_struct() |> atomify()
  def atomify(%{} = map), do: Map.new(map, &atomify_kv/1)
  def atomify(list) when is_list(list), do: Enum.map(list, &atomify/1)
  def atomify(other), do: other

  defp atomify_kv({k, v}) when is_atom(k), do: {k, atomify(v)}
  defp atomify_kv({k, v}), do: {String.to_atom(k), atomify(v)}

  # TODO: Remove this as soon as 1.7.0 is required
  if Version.compare(System.version(), "1.7.0") != :lt do
    defmacro since(version) when is_binary(version) do
      quote do
        @doc since: unquote(version)
      end
    end

    defmacro modulesince(version) when is_binary(version) do
      quote do
        @moduledoc since: unquote(version)
      end
    end

    defmacro typesince(version) when is_binary(version) do
      quote do
        @typedoc since: unquote(version)
      end
    end
  else
    defmacro since(version) when is_binary(version) do
      quote do
        @since unquote(version)
      end
    end

    defmacro modulesince(version) when is_binary(version), do: nil
    defmacro typesince(version) when is_binary(version), do: nil
  end
end
