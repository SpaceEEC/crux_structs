defmodule Crux.Structs.AttachmentTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Attachment

  test "create" do
    attachment =
      %{
        "filename" => "410121532308848640.png",
        "height" => 128,
        "id" => "440894250004250624",
        "proxy_url" =>
          "https://media.discordapp.net/attachments/316880197314019329/440894250004250624/410121532308848640.png",
        "size" => 16914,
        "url" =>
          "https://cdn.discordapp.com/attachments/316880197314019329/440894250004250624/410121532308848640.png",
        "width" => 128
      }
      |> Crux.Structs.create(Crux.Structs.Attachment)

    assert attachment == %Crux.Structs.Attachment{
             filename: "410121532308848640.png",
             height: 128,
             id: 440_894_250_004_250_624,
             proxy_url:
               "https://media.discordapp.net/attachments/316880197314019329/440894250004250624/410121532308848640.png",
             size: 16914,
             url:
               "https://cdn.discordapp.com/attachments/316880197314019329/440894250004250624/410121532308848640.png",
             width: 128
           }
  end

  test "to_string returns url" do
    attachment = %Crux.Structs.Attachment{
      filename: "410121532308848640.png",
      height: 128,
      id: 440_894_250_004_250_624,
      proxy_url:
        "https://media.discordapp.net/attachments/316880197314019329/440894250004250624/410121532308848640.png",
      size: 16914,
      url:
        "https://cdn.discordapp.com/attachments/316880197314019329/440894250004250624/410121532308848640.png",
      width: 128
    }

    stringified = to_string(attachment)

    assert stringified == attachment.url
  end
end
