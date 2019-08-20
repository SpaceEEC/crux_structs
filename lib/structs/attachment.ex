defmodule Crux.Structs.Attachment do
  @moduledoc """
    Represents a Discord [Attachment Object](https://discordapp.com/developers/docs/resources/channel#attachment-object-attachment-structure)

    Height and width are only present for images.
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Attachment, Snowflake, Util}
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
          id: Snowflake.t(),
          filename: String.t(),
          size: integer(),
          url: String.t(),
          proxy_url: String.t(),
          height: integer() | nil,
          width: integer() | nil
        }

  @doc """
    Creates a `t:Crux.Structs.Attachment.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    attachment =
      data
      |> Util.atomify()
      |> Map.update(:id, nil, &Snowflake.to_snowflake/1)

    struct(__MODULE__, attachment)
  end

  defimpl String.Chars, for: Crux.Structs.Attachment do
    @spec to_string(Attachment.t()) :: String.t()
    def to_string(%Attachment{url: url}), do: url
  end
end
