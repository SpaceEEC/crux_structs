defmodule Crux.Structs.AuditLogEntryTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.AuditLogEntry

  alias Crux.Structs
  alias Crux.Structs.{AuditLogChange, AuditLogEntry}

  describe "create/1" do
    test "simple ban add" do
      entry =
        %{
          "action_type" => 22,
          "id" => "700420963971498065",
          "target_id" => "250381145462538242",
          "user_id" => "242685080693243906"
        }
        |> Structs.create(AuditLogEntry)

      assert entry == %AuditLogEntry{
               action_type: 22,
               id: 700_420_963_971_498_065,
               target_id: 250_381_145_462_538_242,
               user_id: 242_685_080_693_243_906
             }

      assert AuditLogEntry.event_name(entry.action_type) == :member_ban_add
    end

    test "webhook delete" do
      entry =
        %{
          "action_type" => 52,
          "changes" => [
            %{"key" => "channel_id", "old_value" => "250372608284033025"},
            %{"key" => "name", "old_value" => "Spidey Bot"},
            %{"key" => "type", "old_value" => 1}
          ],
          "id" => "700684926164402187",
          "target_id" => "700684793939099678",
          "user_id" => "218348062828003328"
        }
        |> Structs.create(AuditLogEntry)

      assert %AuditLogEntry{
               action_type: 52,
               changes: %{
                 "channel_id" => %AuditLogChange{},
                 "name" => %AuditLogChange{},
                 "type" => %AuditLogChange{}
               },
               id: 700_684_926_164_402_187,
               target_id: 700_684_793_939_099_678,
               user_id: 218_348_062_828_003_328
             } = entry

      assert AuditLogEntry.event_name(entry.action_type) == :webhook_delete
    end

    test "overwrite delete" do
      entry =
        %{
          "action_type" => 15,
          "changes" => [
            %{"key" => "id", "old_value" => "243175678227382273"},
            %{"key" => "type", "old_value" => "role"},
            %{"key" => "allow", "old_value" => 0},
            %{"key" => "deny", "old_value" => 0}
          ],
          "id" => "698565876986937475",
          "options" => %{"id" => "243175678227382273", "role_name" => "perms", "type" => "0"},
          "target_id" => "561498582562242560",
          "user_id" => "218348062828003328"
        }
        |> Structs.create(AuditLogEntry)

      assert %AuditLogEntry{
               action_type: 15,
               changes: %{
                 "id" => %AuditLogChange{},
                 "type" => %AuditLogChange{},
                 "allow" => %AuditLogChange{},
                 "deny" => %AuditLogChange{}
               },
               id: 698_565_876_986_937_475,
               target_id: 561_498_582_562_242_560,
               user_id: 218_348_062_828_003_328,
               options: %{
                 id: 243_175_678_227_382_273,
                 role_name: "perms",
                 type: 0
               }
             } = entry

      assert AuditLogEntry.event_name(entry.action_type) == :channel_overwrite_delete
    end

    test "message delete" do
      entry =
        %{
          "action_type" => 72,
          "id" => "700636585569419274",
          "options" => %{"channel_id" => "250372608284033025", "count" => "4"},
          "target_id" => "257884228451041280",
          "user_id" => "218348062828003328"
        }
        |> Structs.create(AuditLogEntry)

      assert %AuditLogEntry{
               action_type: 72,
               id: 700_636_585_569_419_274,
               options: %{
                 channel_id: 250_372_608_284_033_025,
                 count: 4
               },
               target_id: 257_884_228_451_041_280,
               user_id: 218_348_062_828_003_328
             } = entry

      assert AuditLogEntry.event_name(entry.action_type) == :message_delete
    end

    test "member prune" do
      entry =
        %{
          "action_type" => 21,
          "id" => "700722032169713745",
          "options" => %{"delete_member_days" => "7", "members_removed" => "0"},
          "target_id" => nil,
          "user_id" => "242685080693243906"
        }
        |> Structs.create(AuditLogEntry)

      assert %AuditLogEntry{
               action_type: 21,
               id: 700_722_032_169_713_745,
               options: %{
                 delete_member_days: 7,
                 members_removed: 0
               },
               target_id: nil,
               user_id: 242_685_080_693_243_906
             } = entry

      assert AuditLogEntry.event_name(entry.action_type) == :member_prune
    end
  end

  test "events/0 returns map" do
    assert is_map(AuditLogEntry.events())
  end
end
