defmodule Crux.Structs.User do
  @moduledoc """
    Represents a Discord [User Object](https://discordapp.com/developers/docs/resources/user#user-object-user-structure)
  """

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Member, Message, Presence, Snowflake, User, Util, VoiceState}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    avatar: nil,
    bot: false,
    discriminator: nil,
    id: nil,
    username: nil,
    public_flags: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          avatar: String.t() | nil,
          bot: boolean(),
          discriminator: String.t(),
          id: Snowflake.t(),
          username: String.t(),
          public_flags: integer()
        }

  @typedoc """
    All available types that can be resolved into a user id.
  """
  Util.typesince("0.2.1")

  @type id_resolvable() ::
          User.t()
          | Member.t()
          | Message.t()
          | Presence.t()
          | VoiceState.t()
          | Snowflake.t()
          | String.t()

  @doc """
    Resolves the id of a `t:Crux.Structs.Guild.t/0`.

  > Automatically invoked by `Crux.Structs.resolve_id/2`.

    ```elixir
    iex> %Crux.Structs.User{id: 218348062828003328}
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    iex> %Crux.Structs.Member{user: 218348062828003328}
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    iex> %Crux.Structs.Message{author: %Crux.Structs.User{id: 218348062828003328}}
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    iex> %Crux.Structs.Presence{user: 218348062828003328}
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    iex> %Crux.Structs.VoiceState{user_id: 218348062828003328}
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    iex> 218348062828003328
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    iex> "218348062828003328"
    ...> |> Crux.Structs.User.resolve_id()
    218348062828003328

    ```
  """
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
  Util.since("0.2.1")

  def resolve_id(%User{id: id}) do
    resolve_id(id)
  end

  def resolve_id(%Member{user: user}) do
    resolve_id(user)
  end

  def resolve_id(%Message{author: author}) do
    resolve_id(author)
  end

  def resolve_id(%Presence{user: user}) do
    resolve_id(user)
  end

  def resolve_id(%VoiceState{user_id: user_id}) do
    resolve_id(user_id)
  end

  def resolve_id(resolvable), do: Structs.resolve_id(resolvable)

  @doc """
    Creates a `t:Crux.Structs.User.t/0` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    user =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)

    struct(__MODULE__, user)
  end

  @doc ~S"""
    Converts a `t:Crux.Structs.User.t/0` into its discord mention format.

    ```elixir
  iex> %Crux.Structs.User{id: 218348062828003328}
  ...> |> Crux.Structs.User.to_mention()
  "<@218348062828003328>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.User.t()) :: String.t()
  Util.since("0.1.1")
  def to_mention(%__MODULE__{id: id}), do: "<@#{id}>"

  defimpl String.Chars, for: Crux.Structs.User do
    @spec to_string(User.t()) :: String.t()
    def to_string(%User{} = data), do: User.to_mention(data)
  end
end
