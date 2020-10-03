defmodule Crux.Structs do
  @moduledoc """
    Provides a unified function to create one or a list of structs, invoking their `c:create/1` function if available.
  """
  @moduledoc since: "0.1.0"

  alias Crux.Structs.{Snowflake, Util}
  require Snowflake

  @doc """
    Can be implemented by structs to transform the inital data.
  """
  @callback create(data :: map()) :: struct()

  @doc """
    Can be implemented by structs to provide a mechanism to resolve their id.
  """
  @callback resolve_id(data :: map() | Snowflake.t()) :: Snowflake.t() | nil

  @optional_callbacks create: 1, resolve_id: 1

  @doc ~S"""
    Creates a struct or a list of structs invoking their `c:create/1` function if available.

  ## Examples

    ```elixir
    # A single member
    iex> %{
    ...>   "nick" => "nick",
    ...>   "user" => %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "646a356e237350bf8b8dfde15667dfc4"},
    ...>   "roles" => ["251158405832638465", "373405430589816834"],
    ...>   "mute" => false,
    ...>   "deaf" => false,
    ...>   "joined_at" => "2016-11-02T00:51:21.342000+00:00"
    ...> }
    ...> |> Crux.Structs.create(Crux.Structs.Member)
    %Crux.Structs.Member{
      nick: "nick",
      user: 218348062828003328,
      roles: MapSet.new([251158405832638465, 373405430589816834]),
      mute: false,
      deaf: false,
      joined_at: "2016-11-02T00:51:21.342000+00:00",
      guild_id: nil
    }

    # A single user
    iex> %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"}
    ...> |> Crux.Structs.create(Crux.Structs.User)
    %Crux.Structs.User{username: "space", discriminator: "0001", id: 218348062828003328, avatar: "46a356e237350bf8b8dfde15667dfc4"}

    # Multiple users
    iex> [
    ...>   %{"username" => "space", "discriminator" => "0001", "id" => "218348062828003328", "avatar" => "46a356e237350bf8b8dfde15667dfc4"},
    ...>   %{"username" => "Drahcirius", "discriminator" => "1336", "id" => "130175406673231873", "avatar" => "c896aebec82c90f590b08cfebcdc4e3b"}
    ...> ]
    ...> |> Crux.Structs.create(Crux.Structs.User)
    [
      %Crux.Structs.User{username: "space", discriminator: "0001", id: 218348062828003328, avatar: "46a356e237350bf8b8dfde15667dfc4"},
      %Crux.Structs.User{username: "Drahcirius", discriminator: "1336", id: 130175406673231873, avatar: "c896aebec82c90f590b08cfebcdc4e3b"}
    ]

    # Does not alter already structs
    iex> Crux.Structs.create(
    ...>   %Crux.Structs.User{username: "space", discriminator: "0001", id: 218348062828003328, avatar: "46a356e237350bf8b8dfde15667dfc4"},
    ...>   Crux.Structs.User
    ...> )
    %Crux.Structs.User{username: "space", discriminator: "0001", id: 218348062828003328, avatar: "46a356e237350bf8b8dfde15667dfc4"}

    # Fallback
    iex> Crux.Structs.create(nil, nil)
    nil

    ```
  """
  @doc since: "0.1.0"
  @spec create(data :: map(), target :: module()) :: struct()
  @spec create(data :: list(), target :: module()) :: list(struct())
  def create(data, target)
  def create(nil, _), do: nil

  def create(data, target) when is_list(data) do
    Enum.map(data, &create(&1, target))
  end

  def create(%{__struct__: target} = data, target), do: data

  def create(data, target) do
    Code.ensure_loaded(target)

    if :erlang.function_exported(target, :create, 1) do
      target.create(data)
    else
      data = Util.atomify(data)
      struct(target, data)
    end
  end

  @doc """
    Resolves the id of a struct invoking their `c:resolve_id/1` function if available.

    ```elixir
    # Struct of the concrete type
    iex> %Crux.Structs.Webhook{id: 618733351624507394}
    ...> |> Crux.Structs.resolve_id(Crux.Structs.Webhook)
    618733351624507394

    # Already snowflake
    iex> 222089067028807682
    ...> |> Crux.Structs.resolve_id(Crux.Structs.Role)
    222089067028807682

    # Snowflake string
    iex> "222079895583457280"
    ...> |> Crux.Structs.resolve_id(Crux.Structs.Channel)
    222079895583457280

    # nil
    iex> nil
    ...> |> Crux.Structs.resolve_id(Crux.Structs.Guild)
    nil

    # Inexact type that is a resolvable
    iex> %Crux.Structs.Member{user: 218348062828003328}
    ...> |> Crux.Structs.resolve_id(Crux.Structs.User)
    218348062828003328

    # Incorrect type
    iex> %Crux.Structs.Role{id: 222079439876390922}
    ...> |> Crux.Structs.resolve_id(Crux.Structs.Emoji)
    nil

    ```
  """
  @doc since: "0.2.1"
  @spec resolve_id(nil, target :: module()) :: nil
  @spec resolve_id(Snowflake.t(), target :: module()) :: Snowflake.t()
  @spec resolve_id(map(), target :: module()) :: Snowflake.t() | nil

  def resolve_id(data, target) do
    Code.ensure_loaded(target)

    if :erlang.function_exported(target, :resolve_id, 1) do
      target.resolve_id(data)
    else
      case data do
        %^target{id: nil} ->
          resolve_id(data)

        %^target{id: id} ->
          resolve_id(id)

        _ ->
          resolve_id(data)
      end
    end
  end

  @doc false
  @spec resolve_id(Snowflake.t()) :: Snowflake.t()
  @spec resolve_id(String.t()) :: Snowflake.t() | nil
  @spec resolve_id(map()) :: nil
  @spec resolve_id(nil) :: nil
  def resolve_id(snowflake) when Snowflake.is_snowflake(snowflake) do
    snowflake
  end

  def resolve_id(string) when is_binary(string) do
    case Snowflake.parse(string) do
      :error ->
        nil

      snowflake ->
        snowflake
    end
  end

  def resolve_id(%{}), do: nil
  def resolve_id(nil), do: nil
end
