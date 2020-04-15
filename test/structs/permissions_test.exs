defmodule Crux.Structs.PermissionsTest do
  use ExUnit.Case, async: true

  alias Crux.Structs.{Channel, Guild, Member, Overwrite, Permissions, Role}

  doctest Permissions

  test "names/0" do
    names = Permissions.names()

    assert is_list(names)

    assert Enum.size(names) > 0
  end

  test "flags/0" do
    flags = Permissions.flags()

    assert is_map(flags)

    assert map_size(flags) > 0
  end

  test "all/0" do
    assert Permissions.all() > 0
  end

  describe "resolve/1" do
    test "a single bitflag" do
      assert 0x8 == Permissions.resolve(0x8)
    end

    test "a single name" do
      assert 0x8 == Permissions.resolve(:administrator)
    end

    test "a list of names" do
      assert 0xC == Permissions.resolve([:administrator, :ban_members])
    end

    test "a list of names and bitflags" do
      assert 0x10000C40 == Permissions.resolve([:manage_roles, 0x400, 0x800, :add_reactions])
    end

    test "an empty list" do
      assert 0x0 == Permissions.resolve([])
    end
  end

  test "add/2" do
    assert Permissions.new(0x28) == Permissions.add(:administrator, :manage_guild)
  end

  test "remove/2" do
    assert Permissions.new(0x8) == Permissions.remove([0x8, 0x10, 0x20], [0x10, 0x20])
  end

  describe "has/2" do
    test "administrator won't grant any other permissions" do
      refute Permissions.has(0x8, Permissions.all())
    end

    test "resolving a list of names" do
      assert Permissions.has([:send_messages, :view_channel, :read_message_history], [
               :send_messages,
               :view_channel
             ])
    end

    test "resolving different types" do
      assert Permissions.has(:administrator, 0x8)
      assert Permissions.has(0x8, :administrator)
    end
  end

  describe "missing/2" do
    test "basic usage" do
      assert Permissions.new(0x4000) ==
               Permissions.missing([:send_messages, :view_channel], [
                 :send_messages,
                 :view_channel,
                 :embed_links
               ])
    end

    test "administrator does not implicitly grant permissions" do
      assert Permissions.new(0x800) == Permissions.missing([:administrator], [:send_messages])
    end

    test "everything set returns empty bitfield" do
      assert Permissions.new(0x0) ==
               Permissions.missing([:kick_members, :ban_members, :view_audit_log], [
                 :kick_members,
                 :ban_members,
                 :view_audit_log
               ])
    end

    test "no permissions wanted" do
      assert Permissions.new(0x0) == Permissions.missing([:send_messages, :view_channel], [])
    end
  end

  describe "to_map" do
    test "no :administrator set" do
      permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

      Permissions.to_map(permissions)
      |> Enum.each(fn {name, value} ->
        assert {name, name in permissions} === {name, value}
      end)
    end

    test ":administrator set, it does not override" do
      explicit_count =
        :administrator
        |> Permissions.to_map()
        |> Map.values()
        |> Enum.count(& &1)

      assert explicit_count === 1
    end
  end

  describe "to_list/1" do
    test "no :administrator set" do
      permissions = [:view_channel, :send_messages, :kick_members, :embed_links]

      assert permissions === Permissions.to_list(permissions)
    end

    test ":administrator set, it does not override" do
      explicit_count =
        :administrator
        |> Permissions.to_list()
        |> Enum.count()

      assert explicit_count === 1
    end
  end

  describe "implicit/2,3" do
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
  end

  describe "explicit/2,3" do
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
end
