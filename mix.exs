defmodule Crux.Structs.MixProject do
  use Mix.Project

  def project do
    [
      start_permanent: Mix.env() == :prod,
      package: package(),
      app: :crux_structs,
      version: "0.1.2",
      elixir: "~> 1.6",
      description: "Package providing Discord API structs for crux.",
      source_url: "https://github.com/SpaceEEC/crux_structs/",
      homepage_url: "https://github.com/SpaceEEC/crux_structs/",
      deps: deps()
    ]
  end

  def package do
    [
      name: :crux_structs,
      licenses: ["MIT"],
      maintainers: ["SpaceEEC"],
      links: %{
        "GitHub" => "https://github.com/SpaceEEC/crux_structs/",
        "Unified Development Documentation" => "https://crux.randomly.space/"
      }
    ]
  end

  def application, do: []

  defp deps, do: [{:ex_doc, git: "https://github.com/spaceeec/ex_doc", only: :dev}]
end
