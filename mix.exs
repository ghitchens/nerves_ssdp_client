defmodule Nerves.SsdpClient.Mixfile do

  @version "0.0.1"

  use Mix.Project

  def project do
    [app: :nerves_ssdp_client,
     version: @version,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "A simple SSDP client",
     # Hex
     package: package,
     # ExDoc
     name: "Nerves.SSDPClient",
     docs: [source_ref: "v#{@version}",
            main: "Nerves.SSDPClient",
            source_url: "https://github.com/nerves-project/nerves_ssdp_client"],
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    []
  end

  defp package, do: [
    maintainers: ["Garth Hitchens"],
    licenses: ["MIT"],
    links: %{github: "https://github.com/nerves-project/nerves_ssdp_client"},
    files: ~w(lib config) ++
           ~w(README.md CHANGELOG.md LICENSE mix.exs)
  ]

end
