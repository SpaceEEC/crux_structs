defmodule Crux.Structs.MixProject do
  use Mix.Project

  @vsn "0.3.0-dev"
  @name :crux_structs

  def project() do
    [
      start_permanent: Mix.env() == :prod,
      package: package(),
      app: @name,
      version: @vsn,
      elixir: "~> 1.6",
      description: "Library providing Discord API structs for crux.",
      source_url: "https://github.com/SpaceEEC/#{@name}/",
      homepage_url: "https://github.com/SpaceEEC/#{@name}/",
      deps: deps(),
      aliases: aliases(),
      docs: docs()
    ]
  end

  def package() do
    [
      name: @name,
      licenses: ["MIT"],
      maintainers: ["SpaceEEC"],
      links: %{
        "GitHub" => "https://github.com/SpaceEEC/#{@name}/",
        "Changelog" => "https://github.com/SpaceEEC/#{@name}/releases/tag/#{@vsn}/",
        "Documentation" => "https://hexdocs.pm/#{@name}/#{@vsn}/",
        "Unified Development Documentation" => "https://crux.randomly.space/",
        "Crux Libraries Overview" => "https://github.com/SpaceEEC/crux/"
      }
    ]
  end

  def application(), do: []

  defp deps() do
    [
      {:ex_doc, github: "spaceeec/ex_doc", branch: "fork", only: :dev, runtime: false},
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:jason, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases() do
    [
      docs: ["docs", &generate_config/1]
    ]
  end

  defp docs() do
    [
      groups_for_modules: [
        Discord: [
          Crux.Structs.Attachment,
          Crux.Structs.AuditLog,
          Crux.Structs.AuditLogChange,
          Crux.Structs.AuditLogEntry,
          Crux.Structs.Channel,
          Crux.Structs.Embed,
          Crux.Structs.Emoji,
          Crux.Structs.Guild,
          Crux.Structs.GuildPreview,
          Crux.Structs.Integration,
          Crux.Structs.Invite,
          Crux.Structs.Member,
          Crux.Structs.Message,
          Crux.Structs.Overwrite,
          Crux.Structs.Presence,
          Crux.Structs.Reaction,
          Crux.Structs.Role,
          Crux.Structs.User,
          Crux.Structs.VoiceRegion,
          Crux.Structs.VoiceState,
          Crux.Structs.Webhook
        ],
        BitFields: [
          Crux.Structs.Guild.SystemChannelFlags,
          Crux.Structs.Message.Flags,
          Crux.Structs.Permissions,
          Crux.Structs.Presence.ActivityFlags,
          Crux.Structs.User.Flags
        ],
        Utility: ~r/.+/
      ],
      nest_modules_by_prefix: [
        Crux.Structs
      ],
      formatters: ["html"]
    ]
  end

  def generate_config(_) do
    {data, 0} = System.cmd("git", ["tag"])

    config =
      data
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&%{"url" => "https://hexdocs.pm/#{@name}/" <> &1, "version" => &1})
      |> Enum.reverse()
      |> Jason.encode!()

    config = "var versionNodes = " <> config

    path =
      __ENV__.file
      |> Path.join(Path.join(["..", "doc", "docs_config.js"]))
      |> Path.expand()

    File.write!(path, config)

    Mix.Shell.IO.info(~s{Generated "#{path}".})
  end
end
