defmodule Crux.Structs.EmbedTest do
  use ExUnit.Case, async: true
  doctest Crux.Structs.Embed

  test "create" do
    embed =
      %{
        "description" => "some description",
        "author" => %{"url" => "https://www.youtube.com/user/user", "name" => "user"},
        "url" => "https://www.youtube.com/watch?v=video",
        "title" => "Video Title",
        "color" => 16_711_680,
        "video" => %{
          "url" => "https://www.youtube.com/embed/video",
          "width" => 1280,
          "height" => 720
        },
        "provider" => %{"url" => "https://www.youtube.com/", "name" => "YouTube"},
        "type" => "video",
        "thumbnail" => %{
          "url" => "https://i.ytimg.com/vi/video/maxresdefault.jpg",
          "width" => 1280,
          "proxy_url" => "https://images-ext-2.discordapp.net/external/video/maxresdefault.jpg",
          "height" => 720
        }
      }
      |> Crux.Structs.create(Crux.Structs.Embed)

    assert embed == %Crux.Structs.Embed{
             author: %{url: "https://www.youtube.com/user/user", name: "user"},
             color: 16_711_680,
             description: "some description",
             fields: nil,
             url: "https://www.youtube.com/watch?v=video",
             provider: %{
               url: "https://www.youtube.com/",
               name: "YouTube"
             },
             thumbnail: %{
               url: "https://i.ytimg.com/vi/video/maxresdefault.jpg",
               width: 1280,
               proxy_url: "https://images-ext-2.discordapp.net/external/video/maxresdefault.jpg",
               height: 720
             },
             title: "Video Title",
             type: "video",
             video: %{
               height: 720,
               url: "https://www.youtube.com/embed/video",
               width: 1280
             }
           }
  end
end
