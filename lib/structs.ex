defmodule Crux.Structs do
  @moduledoc """
    Provides a unified function to create one or a list of structs, invoking their `create/1` function if available.
  """

  alias Crux.Structs.Util

  @doc """
    Creates a struct or a list of structs invoking their `create/1` function if available.
  """
  @spec create(data :: map() | list(), target :: module()) :: struct() | list()
  def create(data, target)
  def create(nil, _target), do: nil

  def create(data, target) when is_list(data) do
    Enum.map(data, &create(&1, target))
  end

  def create(data, target) do
    if Keyword.has_key?(target.__info__(:functions), :create) do
      target.create(data)
    else
      data = Util.atomify(data)
      struct(target, data)
    end
  end
end
