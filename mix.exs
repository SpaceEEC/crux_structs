defmodule Crux.Structs.MixProject do
  use Mix.Project

  def project do
    [
      app: :crux_structs,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      package: package(),
      source_url: "https://github.com/SpaceEEC/crux_structs/",
      homepage_url: "https://github.com/SpaceEEC/crux_structs/",
      deps: deps(),
    ]
  end

  def package do
    [
      name: :crux_structs,
      licenses: ["MIT"],
      maintainers: ["SpaceEEC"],
      links: %{
        "GitHub" => "https://github.com/SpaceEEC/crux_structs/",
        "Docs" => "https://hexdocs.pm/crux_structs"
      }
    ]
  end
  def application, do: []

  defp deps, do: [{:ex_doc, "~> 0.18.3", only: :dev}]
end
