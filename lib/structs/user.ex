defmodule Crux.Structs.User do
  @moduledoc """
    Represents a Discord [User Object](https://discord.com/developers/docs/resources/user#user-object)
  """
  @moduledoc since: "0.1.0"

  @behaviour Crux.Structs

  alias Crux.Structs
  alias Crux.Structs.{Member, Message, Presence, Snowflake, User, Util, VoiceState}

  defstruct [
    :id,
    :username,
    :discriminator,
    :avatar,
    :bot,
    :system,
    :public_flags
  ]

  @typedoc since: "0.1.0"
  @type t :: %__MODULE__{
          id: Snowflake.t(),
          username: String.t(),
          discriminator: String.t(),
          avatar: String.t() | nil,
          bot: boolean(),
          system: boolean(),
          public_flags: User.Flags.t()
        }

  @typedoc """
    All available types that can be resolved into a user id.
  """
  @typedoc since: "0.2.1"
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
  @doc since: "0.2.1"
  @spec resolve_id(id_resolvable()) :: Snowflake.t() | nil
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
  @doc since: "0.1.0"
  @spec create(data :: map()) :: t()
  def create(data) do
    user =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Snowflake.to_snowflake/1)
      |> Map.put_new(:bot, false)
      |> Map.put_new(:system, false)
      |> Map.update(:public_flags, nil, &User.Flags.resolve/1)

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
  @doc since: "0.1.1"
  @spec to_mention(user :: Crux.Structs.User.t()) :: String.t()
  def to_mention(%__MODULE__{id: id}), do: "<@#{id}>"

  defimpl String.Chars, for: Crux.Structs.User do
    @spec to_string(User.t()) :: String.t()
    def to_string(%User{} = data), do: User.to_mention(data)
  end
end
