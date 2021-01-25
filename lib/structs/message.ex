defmodule Crux.Structs.Message do
  @moduledoc """
    Represents a Discord [Message Object](https://discord.com/developers/docs/resources/channel#message-object).

    Differences opposed to the Discord API Object:
    - `:mentions` is a MapSet of user ids
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs

  alias Crux.Structs.{
    Application,
    Attachment,
    Embed,
    Member,
    Message,
    Reaction,
    Snowflake,
    Sticker,
    User,
    Util
  }

  defstruct [
    :id,
    :channel_id,
    :guild_id,
    :author,
    :member,
    :content,
    :timestamp,
    :edited_timestamp,
    :tts,
    :mention_everyone,
    :mentions,
    :mention_roles,
    :mention_channels,
    :attachments,
    :embeds,
    :reactions,
    :nonce,
    :pinned,
    :webhook_id,
    :type,
    :activity,
    :application,
    :message_reference,
    :flags,
    :stickers,
    :referenced_message
  ]

  @typedoc since: "0.2.1"
  @type message_activity :: %{
          optional(:party_id) => String.t(),
          type: integer()
        }

  @typedoc since: "0.2.1"
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
  @typedoc since: "0.2.1"
  @type message_reference :: %{
          message_id: Snowflake.t() | nil,
          guild_id: Snowflake.t() | nil,
          channel_id: Snowflake.t()
        }

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          channel_id: Snowflake.t(),
          guild_id: Snowflake.t() | nil,
          author: User.t(),
          member: Member.t() | nil,
          content: String.t(),
          timestamp: String.t(),
          edited_timestamp: String.t() | nil,
          tts: boolean(),
          mention_everyone: boolean(),
          mentions: MapSet.t(Snowflake.t()),
          mention_roles: MapSet.t(Snowflake.t()),
          mention_channels: [mention_channel()],
          attachments: [Attachment.t()],
          embeds: [Embed.t()],
          reactions: %{String.t() => Reaction.t()},
          nonce: String.t() | nil,
          pinned: boolean(),
          webhook_id: Snowflake.t() | nil,
          type: integer(),
          activity: message_activity() | nil,
          application: Application.t() | nil,
          message_reference: message_reference(),
          flags: Message.Flags.t()
        }

  @typedoc """
    All available types that can be resolved into a message id.
  """
  @typedoc since: "0.2.1"
  @type id_resolvable() :: Message.t() | Snowflake.t() | String.t()

  @doc """
    Creates a `t:Crux.Structs.Message.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update(:application, nil, &Structs.create(&1, Application))
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
      |> Map.update(:flags, nil, &Message.Flags.resolve/1)
      |> Map.update(:stickers, nil, &Util.raw_data_to_map(&1, Sticker))
      |> Map.update(:referenced_message, nil, &create(&1))

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
