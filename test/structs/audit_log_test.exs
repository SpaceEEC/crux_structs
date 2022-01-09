defmodule Crux.Structs.AuditLogTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.AuditLog

  alias Crux.Structs
  alias Crux.Structs.{AuditLog, AuditLogEntry, Integration, User, Webhook}

  describe "create/1" do
    test "no entries" do
      audit_log =
        %{
          "audit_log_entries" => [],
          "guild_scheduled_events" => [],
          "integrations" => [],
          "threads" => [],
          "users" => [],
          "webhooks" => []
        }
        |> Structs.create(AuditLog)

      assert audit_log == %AuditLog{
               audit_log_entries: %{},
               guild_scheduled_events: %{},
               integrations: %{},
               threads: %{},
               users: %{},
               webhooks: %{}
             }
    end

    test "structures will be created" do
      audit_log =
        %{
          "audit_log_entries" => [
            %{
              "action_type" => 50,
              "changes" => [
                %{"key" => "channel_id", "new_value" => "250372608284033025"},
                %{"key" => "name", "new_value" => "Spidey Bot"},
                %{"key" => "type", "new_value" => 1}
              ],
              "id" => "700684793939099679",
              "target_id" => "700684793939099678",
              "user_id" => "218348062828003328"
            }
          ],
          "integrations" => [
            %{
              "id" => 33_590_653_072_239_123,
              "name" => "A Name",
              "type" => "twitch",
              "account" => %{
                "name" => "twitchusername",
                "id" => "1234567"
              }
            }
          ],
          "users" => [
            %{
              "avatar" => "646a356e237350bf8b8dfde15667dfc4",
              "discriminator" => "0001",
              "id" => "218348062828003328",
              "public_flags" => 512,
              "username" => "space"
            }
          ],
          "webhooks" => [
            %{
              "avatar" => nil,
              "channel_id" => "250372608284033025",
              "guild_id" => "243175181885898762",
              "id" => "700684793939099678",
              "name" => "Spidey Bot",
              "type" => 1
            }
          ]
        }
        |> Structs.create(AuditLog)

      assert %AuditLog{
               audit_log_entries: %{
                 700_684_793_939_099_679 => %AuditLogEntry{
                   id: 700_684_793_939_099_679
                 }
               },
               integrations: %{
                 33_590_653_072_239_123 => %Integration{
                   id: 33_590_653_072_239_123
                 }
               },
               users: %{
                 218_348_062_828_003_328 => %User{
                   id: 218_348_062_828_003_328
                 }
               },
               webhooks: %{
                 700_684_793_939_099_678 => %Webhook{
                   id: 700_684_793_939_099_678
                 }
               }
             } = audit_log
    end
  end
end
