defmodule Nerves.SsdpClient.Mixfile do

  @version "0.1.1"

  use Mix.Project

  def project, do: [
    app: :nerves_ssdp_client,
    version: @version,
    elixir: "~> 1.1",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps,
    # Hex
    description: "A simple SSDP client",
    package: package,
    # ExDoc
    name: "Nerves.SSDPClient",
    docs: [source_ref: "v#{@version}",
           main: "Nerves.SSDPClient",
           source_url: "https://github.com/nerves-project/nerves_ssdp_client"]
  ]

  def application do
    [applications: [:logger],
     mod: {Nerves.SSDPClient, []}]
  end

  defp deps, do: [
    {:nerves_ssdp_server, github: "nerves-project/nerves_ssdp_server", only: :test}
  ]

  defp package, do: [
    maintainers: ["Garth Hitchens"],
    licenses: ["MIT"],
    links: %{github: "https://github.com/nerves-project/nerves_ssdp_client"},
    files: ~w(lib config) ++
           ~w(README.md CHANGELOG.md LICENSE mix.exs)
  ]

end
