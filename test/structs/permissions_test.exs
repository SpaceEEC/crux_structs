defmodule Crux.Structs.PermissionsTest do
  use ExUnit.Case, async: true

  alias Crux.Structs.{Channel, Guild, Member, Overwrite, Permissions, Role}

  doctest Permissions

  test "to_map" do
    permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

    Permissions.to_map(permissions)
    |> Enum.each(fn {name, value} ->
      assert {name, name in permissions} === {name, value}
    end)
  end

  test "to_map administrator explicit" do
    explicit_count =
      :administrator
      |> Permissions.to_map()
      |> Map.values()
      |> Enum.count(& &1)

    assert explicit_count === 1
  end

  test "to_map administrator implicit" do
    implicit_count =
      :administrator
      |> Permissions.to_map(true)
      |> Map.values()
      |> Enum.count(& &1)

    all_count =
      Permissions.names()
      |> Enum.count()

    assert implicit_count === all_count
  end

  test "to_list" do
    permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

    assert permissions === Permissions.to_list(permissions)
  end

  test "to_list administrator explicit" do
    explicit_count =
      :administrator
      |> Permissions.to_list()
      |> Enum.count()

    assert explicit_count === 1
  end

  test "to_list administrator implicit" do
    implicit_count =
      :administrator
      |> Permissions.to_list(true)
      |> Enum.count()

    all_count =
      Permissions.names()
      |> Enum.count()

    assert implicit_count === all_count
  end

  test "from/2 owner overrides" do
    member = %Member{user: 218_348_062_828_003_328}
    guild = %Guild{owner_id: 218_348_062_828_003_328}

    %Permissions{bitfield: bitfield} = Permissions.from(member, guild)

    assert bitfield === Permissions.all()
  end

  test "from/2 administrator overrides" do
    [member, guild, _] = test_data(true)

    %Permissions{bitfield: bitfield} = Permissions.from(member, guild)

    assert bitfield === Permissions.all()
  end

  test "from/2" do
    [member, guild, _] = test_data()

    %Permissions{bitfield: bitfield} = Permissions.from(member, guild)

    assert bitfield ===
             Permissions.resolve([
               :view_channel,
               :send_messages,
               :kick_members,
               :ban_members,
               :read_message_history
             ])
  end

  test "from/3 administrator override" do
    [member, guild, channel] = test_data(true)

    %Permissions{bitfield: bitfield} = Permissions.from(member, guild, channel)

    assert bitfield === Permissions.all()
  end

  test "from/3" do
    [member, guild, channel] = test_data()

    %Permissions{bitfield: bitfield} = Permissions.from(member, guild, channel)

    assert bitfield ===
             Permissions.resolve([
               :send_messages,
               :kick_members,
               :ban_members,
               :read_message_history
             ])
  end

  test "from/3 edge case with administrator in overwrite" do
    [member, guild, channel] =
      test_data(false, allow: Permissions.resolve([:administrator]), deny: 0)

    %Permissions{bitfield: bitfield} = Permissions.from(member, guild, channel)

    # not equal to Permissions.all() !
    assert bitfield ===
             Permissions.resolve([
               :administrator,
               :view_channel,
               :send_messages,
               :kick_members,
               :ban_members,
               :read_message_history
             ])
  end

  defp test_data(admin \\ false, channel_perms \\ []) do
    member = %Member{user: 218_348_062_828_003_328}

    guild = %Guild{
      id: 243_175_181_885_898_762,
      members: %{
        218_348_062_828_003_328 => %Member{
          roles: MapSet.new([251_158_405_832_638_465, 373_405_430_589_816_834])
        }
      },
      roles: %{
        # @everyone
        243_175_181_885_898_762 => %Role{
          permissions: Permissions.resolve([:view_channel, :send_messages])
        },
        251_158_405_832_638_465 => %Role{
          permissions: Permissions.resolve([:kick_members, :ban_members])
        },
        373_405_430_589_816_834 => %Role{
          permissions:
            Permissions.resolve([if(admin, do: :administrator, else: :read_message_history)])
        }
      }
    }

    channel = %Channel{
      permission_overwrites: %{
        243_175_181_885_898_762 => %Overwrite{
          allow: channel_perms[:allow] || 0,
          deny: channel_perms[:deny] || Permissions.resolve([:view_channel])
        }
      }
    }

    [member, guild, channel]
  end
end
