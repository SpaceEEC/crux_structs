defmodule Crux.Structs.Message do
  @moduledoc """
    Represents a Discord [Message Object](https://discordapp.com/developers/docs/resources/channel#message-object-message-structure).
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Attachment, Embed, Reaction, User, Util}

  defstruct(
    id: nil,
    channel_id: nil,
    author: nil,
    content: nil,
    timestamp: nil,
    edited_timestamp: nil,
    guild_id: nil,
    tts: false,
    mention_everyone: false,
    mentions: [],
    mention_roles: [],
    attachments: [],
    embeds: [],
    reactions: [],
    nonce: nil,
    pinned: false,
    webhook_id: nil,
    type: 0
  )

  @type t :: %__MODULE__{
          id: integer(),
          channel_id: integer(),
          # Might be webhook
          author: User.t(),
          content: String.t(),
          timestamp: String.t(),
          edited_timestamp: String.t(),
          guild_id: integer() | nil,
          tts: boolean(),
          mention_everyone: boolean(),
          mentions: MapSet.t(integer()),
          mention_roles: MapSet.t(integer()),
          attachments: [Attachment.t()],
          embeds: [Embed.t()],
          reactions: %{String.t() => Reaction.t()},
          nonce: String.t() | nil,
          pinned: boolean(),
          webhook_id: integer() | nil,
          type: integer()
        }

  @doc """
    Creates a `Crux.Structs.Message` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)
      |> Map.update!(:channel_id, &Util.id_to_int/1)
      |> Map.update!(:author, &Structs.create(&1, User))
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)
      |> Map.update(
        :mentions,
        %MapSet{},
        &MapSet.new(&1, fn user -> Map.get(user, :id) |> Util.id_to_int() end)
      )
      |> Map.update(
        :mention_roles,
        %MapSet{},
        &MapSet.new(&1, fn role_id -> Util.id_to_int(role_id) end)
      )
      |> Map.update(:attachments, [], &Structs.create(&1, Attachment))
      |> Map.update(:embeds, [], &Structs.create(&1, Embed))
      |> Map.update(
        :reactions,
        %{},
        &Map.new(&1, fn reaction ->
          reaction = Structs.create(reaction, Reaction)
          id = reaction.emoji.id || reaction.emoji.name

          {id, reaction}
        end)
      )
      |> Map.update(:webhook_id, nil, &Util.id_to_int/1)

    struct(__MODULE__, data)
  end

  defimpl String.Chars, for: Crux.Structs.Message do
    def to_string(%Crux.Structs.Message{content: content}), do: content
  end
end
