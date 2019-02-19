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

  test "to_map administrator does not override" do
    explicit_count =
      :administrator
      |> Permissions.to_map()
      |> Map.values()
      |> Enum.count(& &1)

    assert explicit_count === 1
  end

  test "to_list" do
    permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

    assert permissions === Permissions.to_list(permissions)
  end

  test "to_list administrator does not override" do
    explicit_count =
      :administrator
      |> Permissions.to_list()
      |> Enum.count()

    assert explicit_count === 1
  end

  test "implicit/2 owner overrides" do
    member = %Member{user: 218_348_062_828_003_328}
    guild = %Guild{owner_id: 218_348_062_828_003_328}

    %Permissions{bitfield: bitfield} = Permissions.implicit(member, guild)

    assert bitfield === Permissions.all()
  end

  test "implicit/2 administrator overrides" do
    [member, guild, _] = test_data()

    %Permissions{bitfield: bitfield} = Permissions.implicit(member, guild)

    assert bitfield === Permissions.all()
  end

  test "implicit/3 administrator override" do
    [member, guild, channel] = test_data()

    %Permissions{bitfield: bitfield} = Permissions.implicit(member, guild, channel)

    assert bitfield === Permissions.all()
  end

  test "implicit/3 administrator in overwrite does not override" do
    [member, guild, channel] =
      test_data(no_admin: true, allow: Permissions.resolve([:administrator]), deny: 0)

    %Permissions{bitfield: bitfield} = Permissions.implicit(member, guild, channel)

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

  test "explicit/2 administrator nor owner does not override" do
    [member, guild, _] = test_data()
    guild = Map.put(guild, :owner, member.user)

    %Permissions{bitfield: bitfield} = Permissions.explicit(member, guild)

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

  test "explicit/3 administrator nor owner does not override" do
    [member, guild, channel] = test_data(allow: Permissions.resolve([:administrator]))
    guild = Map.put(guild, :owner, member.user)

    %Permissions{bitfield: bitfield} = Permissions.explicit(member, guild, channel)

    assert bitfield ===
             Permissions.resolve([
               :administrator,
               :send_messages,
               :kick_members,
               :ban_members,
               :read_message_history
             ])
  end

  test "no roles does not raise" do
    [member, guild, _] = test_data()

    guild =
      Map.update!(
        guild,
        :members,
        fn members ->
          Map.update!(members, 218_348_062_828_003_328, &Map.put(&1, :roles, MapSet.new()))
        end
      )

    assert guild.members[218_348_062_828_003_328].roles |> MapSet.size() === 0

    %Permissions{bitfield: bitfield} = Permissions.explicit(member, guild)

    assert bitfield === Permissions.resolve([:view_channel, :send_messages])
  end

  defp test_data(options \\ []) do
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
            Permissions.resolve([
              if(options[:no_admin], do: 0, else: :administrator),
              :read_message_history
            ])
        }
      }
    }

    channel = %Channel{
      permission_overwrites: %{
        243_175_181_885_898_762 => %Overwrite{
          allow: options[:allow] || 0,
          deny: options[:deny] || Permissions.resolve([:view_channel])
        }
      }
    }

    [member, guild, channel]
  end
end
