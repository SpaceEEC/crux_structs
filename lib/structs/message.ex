defmodule Crux.Structs.Message do
  @moduledoc """
    Represents a Discord [Message Object](https://discordapp.com/developers/docs/resources/channel#message-object-message-structure).

    Differences opposed to the Discord API Object:
    - `:mentions` is a MapSet of user ids
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Attachment, Embed, Member, Message, Reaction, Snowflake, User, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    activity: nil,
    application: nil,
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
    mention_channels: [],
    mention_everyone: false,
    mention_roles: MapSet.new(),
    mentions: MapSet.new(),
    message_reference: nil,
    nonce: nil,
    pinned: nil,
    reactions: %{},
    timestamp: nil,
    tts: nil,
    type: 0,
    webhook_id: nil
  )

  Util.typesince("0.2.1")

  @type message_activity :: %{
          optional(:party_id) => String.t(),
          type: integer()
        }

  Util.typesince("0.2.1")

  @type message_application :: %{
          id: Snowflake.t(),
          cover_image: String.t() | nil,
          description: String.t(),
          icon: String.t() | nil,
          name: String.t()
        }

  Util.typesince("0.2.1")

  @type mention_channel :: %{
          id: Snowflake.t(),
          guild_id: Snowflake.t(),
          name: String.t(),
          type: non_neg_integer()
        }

  @typedoc """
  * `message_id` is `nil` for the initial message sent when a user starts following a channel.
  * `guild_id` is only `nil` for some messages during the initial rollout of this feature.
  """
  Util.typesince("0.2.1")

  @type message_reference :: %{
          message_id: Snowflake.t() | nil,
          guild_id: Snowflake.t() | nil,
          channel_id: Snowflake.t()
        }

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          activity: message_activity() | nil,
          application: message_application() | nil,
          attachments: [Attachment.t()],
          # Might be a webhook user
          author: User.t(),
          channel_id: Snowflake.t(),
          content: String.t(),
          edited_timestamp: String.t(),
          embeds: [Embed.t()],
          flags: non_neg_integer(),
          guild_id: Snowflake.t() | nil,
          id: Snowflake.t(),
          member: Member.t() | nil,
          mention_channels: [mention_channel()],
          mention_everyone: boolean(),
          mention_roles: MapSet.t(Snowflake.t()),
          mentions: MapSet.t(Snowflake.t()),
          message_reference: message_reference(),
          nonce: String.t() | nil,
          pinned: boolean(),
          reactions: %{String.t() => Reaction.t()},
          timestamp: String.t(),
          tts: boolean(),
          type: integer(),
          webhook_id: Snowflake.t() | nil
        }

  @typedoc """
    All available types that can be resolved into a message id.
  """
  Util.typesince("0.2.1")
  @type id_resolvable() :: Message.t() | Snowflake.t() | String.t()

  @doc """
    Creates a `t:Crux.Structs.Message.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(
        :application,
        nil,
        &Map.update(&1, :id, nil, fn id -> Snowflake.to_snowflake(id) end)
      )
      |> Map.update(:attachments, [], &Structs.create(&1, Attachment))
      |> Map.update!(:author, &Structs.create(&1, User))
      |> Map.update!(:channel_id, &Snowflake.to_snowflake/1)
      |> Map.update(:embeds, [], &Structs.create(&1, Embed))
      |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.update(:mention_channels, [], &create_mention_channel/1)
      |> Map.update(
        :mention_roles,
        %MapSet{},
        &MapSet.new(&1, fn role_id -> Snowflake.to_snowflake(role_id) end)
      )
      |> Map.update(:mentions, %MapSet{}, &MapSet.new(&1, Util.map_to_id()))
      |> Map.update(:message_reference, nil, &create_message_reference/1)
      |> Map.update(
        :reactions,
        %{},
        &Map.new(&1, fn reaction ->
          reaction = Structs.create(reaction, Reaction)
          key = reaction.emoji.id || reaction.emoji.name

          {key, reaction}
        end)
      )
      |> Map.update(:webhook_id, nil, &Snowflake.to_snowflake/1)

    message = Map.update(data, :member, nil, create_member(data))

    struct(__MODULE__, message)
  end

  defp create_mention_channel(mention_channels)
       when is_list(mention_channels) do
    Enum.map(mention_channels, &create_mention_channel/1)
  end

  defp create_mention_channel(%{} = mention_channel) do
    mention_channel
    |> Map.update!(:id, &Snowflake.to_snowflake/1)
    |> Map.update!(:guild_id, &Snowflake.to_snowflake/1)
  end

  defp create_message_reference(%{} = message_reference) do
    message_reference
    |> Map.update(:message_id, nil, &Snowflake.to_snowflake/1)
    |> Map.update(:channel_id, nil, &Snowflake.to_snowflake/1)
    |> Map.update(:guild_id, nil, &Snowflake.to_snowflake/1)
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
