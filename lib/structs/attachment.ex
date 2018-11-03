defmodule Crux.Structs.Attachment do
  @moduledoc """
    Represents a Discord [Attachment Object](https://discordapp.com/developers/docs/resources/channel#attachment-object-attachment-structure)

    Height and width are only present for images.
  """

  @behaviour Crux.Structs

  alias Crux.Structs.Util
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    id: nil,
    filename: nil,
    size: nil,
    url: nil,
    proxy_url: nil,
    height: nil,
    width: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          id: Crux.Rest.snowflake(),
          filename: String.t(),
          size: integer(),
          url: String.t(),
          proxy_url: String.t(),
          height: integer() | nil,
          width: integer() | nil
        }

  @doc """
    Creates a `Crux.Structs.Attachment` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  Util.since("0.1.0")

  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end

  defimpl String.Chars, for: Crux.Structs.Attachment do
    def to_string(%Crux.Structs.Attachment{url: url}), do: url
  end
end
