defmodule Crux.Structs do
  @moduledoc """
    Provides a unified function to create one or a list of structs, invoking their `create/1` function if available.
  """

  alias Crux.Structs.Util

  @doc """
    Can be implemented by structs to transform the inital data.
  """
  @callback create(data :: map()) :: struct()
  @optional_callbacks create: 1

  @doc ~S"""
    Creates a struct or a list of structs invoking their `create/1` function if available.

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
  iex> Crux.Structs.create(%Crux.Structs.Member{}, Crux.Structs.Member)
  %Crux.Structs.Member{}

  # Fallback
  iex> Crux.Structs.create(nil, nil)
  nil

  ```
  """
  @spec create(data :: map(), target :: module()) :: struct()
  @spec create(data :: list(), target :: module()) :: list(struct())
  @doc since: "0.1.0"
  def create(data, target)
  def create(nil, _target), do: nil

  def create(data, target) when is_list(data) do
    Enum.map(data, &create(&1, target))
  end

  def create(%{__struct__: target} = data, target), do: data

  def create(data, target) do
    if Keyword.has_key?(target.__info__(:functions), :create) do
      target.create(data)
    else
      data = Util.atomify(data)
      struct(target, data)
    end
  end
end
