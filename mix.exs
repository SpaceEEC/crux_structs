defmodule Crux.Structs.MixProject do
  use Mix.Project

  @vsn "0.1.6"
  @name :crux_structs

  def project do
    [
      start_permanent: Mix.env() == :prod,
      package: package(),
      app: @name,
      version: @vsn,
      elixir: "~> 1.6",
      description: "Package providing Discord API structs for crux.",
      source_url: "https://github.com/SpaceEEC/crux_structs/",
      homepage_url: "https://github.com/SpaceEEC/crux_structs/",
      deps: deps()
    ]
  end

  def package do
    [
      name: @name,
      licenses: ["MIT"],
      maintainers: ["SpaceEEC"],
      links: %{
        "GitHub" => "https://github.com/SpaceEEC/#{@name}/",
        "Changelog" => "https://github.com/SpaceEEC/#{@name}/releases/tag/#{@vsn}/",
        "Documentation" => "https://hexdocs.pm/#{@name}/#{@vsn}",
        "Unified Development Documentation" => "https://crux.randomly.space/"
      }
    ]
  end

  def application, do: []

  defp deps do
    [
      {:ex_doc, git: "https://github.com/spaceeec/ex_doc", only: :dev, runtime: false}
    ]
  end
end
