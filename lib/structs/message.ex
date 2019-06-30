defmodule Crux.Structs.Message do
  @moduledoc """
    Represents a Discord [Message Object](https://discordapp.com/developers/docs/resources/channel#message-object-message-structure).

    Differences opposed to the Discord API Object:
    - `:mentions` is a MapSet of user ids
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Attachment, Embed, Member, Message, Reaction, User, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    attachments: [],
    author: nil,
    channel_id: nil,
    content: nil,
    edited_timestamp: nil,
    embeds: [],
    flags: 0,
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

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          attachments: [Attachment.t()],
          # Might be webhook
          author: User.t(),
          channel_id: Crux.Rest.snowflake(),
          content: String.t(),
          edited_timestamp: String.t(),
          embeds: [Embed.t()],
          flags: integer(),
          guild_id: Crux.Rest.snowflake() | nil,
          id: Crux.Rest.snowflake(),
          member: Member.t() | nil,
          mention_everyone: boolean(),
          mention_roles: MapSet.t(Crux.Rest.snowflake()),
          mentions: MapSet.t(Crux.Rest.snowflake()),
          nonce: String.t() | nil,
          pinned: boolean(),
          timestamp: String.t(),
          tts: boolean(),
          type: integer(),
          reactions: %{String.t() => Reaction.t()},
          webhook_id: Crux.Rest.snowflake() | nil
        }

  @doc """
    Creates a `Crux.Structs.Message` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

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

    message =
      data
      |> Map.update(:member, nil, create_member(data))
      |> Map.update(
        :mention_roles,
        %MapSet{},
        &MapSet.new(&1, fn role_id -> Util.id_to_int(role_id) end)
      )
      |> Map.update(:mentions, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))
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

    struct(__MODULE__, message)
  end

  defp create_member(data) do
    fn member ->
      member
      |> Map.put(:guild_id, data.guild_id)
      |> Map.put(:user, %{id: data.author.id})
      |> Structs.create(Member)
    end
  end

  defimpl String.Chars, for: Crux.Structs.Message do
    @spec to_string(Message.t()) :: String.t()
    def to_string(%Message{content: content}), do: content
  end
end
