defmodule Crux.Structs.Attachment do
  @moduledoc """
    Represents a Discord [Attachment Object](https://discord.com/developers/docs/resources/channel#attachment-object)

    Height and width are only present for images.
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs.{Attachment, Snowflake, Util}

  defstruct [
    :id,
    :filename,
    :size,
    :url,
    :proxy_url,
    :height,
    :width
  ]

  @typedoc since: "0.1.0"
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
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
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
