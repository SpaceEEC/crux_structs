defmodule Crux.Structs.Message do
  @moduledoc """
    Represents a Discord [Message Object](https://discordapp.com/developers/docs/resources/channel#message-object-message-structure).
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Attachment, Embed, Member, Reaction, User, Util}

  defstruct(
    attachments: [],
    author: nil,
    channel_id: nil,
    content: nil,
    edited_timestamp: nil,
    embeds: [],
    guild_id: nil,
    id: nil,
    member: nil,
    mention_everyone: false,
    mention_roles: MapSet.new(),
    mentions: MapSet.new(),
    nonce: nil,
    pinned: false,
    timestamp: nil,
    tts: false,
    type: 0,
    reactions: %{},
    webhook_id: nil
  )

  @type t :: %__MODULE__{
          attachments: [Attachment.t()],
          # Might be webhook
          author: User.t(),
          channel_id: integer(),
          content: String.t(),
          edited_timestamp: String.t(),
          embeds: [Embed.t()],
          guild_id: integer() | nil,
          id: integer(),
          member: Member.t() | nil,
          mention_everyone: boolean(),
          mention_roles: MapSet.t(integer()),
          mentions: MapSet.t(integer()),
          nonce: String.t() | nil,
          pinned: boolean(),
          timestamp: String.t(),
          tts: boolean(),
          type: integer(),
          reactions: %{String.t() => Reaction.t()},
          webhook_id: integer() | nil
        }

  @doc """
    Creates a `Crux.Structs.Message` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:attachments, [], &Structs.create(&1, Attachment))
      |> Map.update!(:author, &Structs.create(&1, User))
      |> Map.update!(:channel_id, &Util.id_to_int/1)
      |> Map.update(:embeds, [], &Structs.create(&1, Embed))
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)
      |> Map.update!(:id, &Util.id_to_int/1)

    data =
      data
      |> Map.update(:member, nil, fn member ->
        member
        |> Map.put(:guild_id, data.guild_id)
        |> Map.put(:user, %{id: data.author.id})
        |> Structs.create(Member)
      end)
      |> Map.update(
        :mention_roles,
        %MapSet{},
        &MapSet.new(&1, fn role_id -> Util.id_to_int(role_id) end)
      )
      |> Map.update(
        :mentions,
        %MapSet{},
        &MapSet.new(&1, fn user -> Map.get(user, :id) |> Util.id_to_int() end)
      )
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
