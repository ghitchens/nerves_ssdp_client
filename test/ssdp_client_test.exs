defmodule Nerves.SSDPClientTest do
  alias Nerves.SSDPClient
  alias Nerves.SSDPServer
  use ExUnit.Case, async: true

  doctest SSDPClient

  @test_usn "uid:test:my_usn"
  @test_fields [
    location: "http://there/",
    st: "nerves-project-org:test-service:1",
    server: "SSDPServerTest",
    "cache-control": "max-age=1800"
  ]

  # `setup_all` is called once before every test
  setup_all do
    :application.start :nerves_ssdp_server
    SSDPServer.publish @test_usn, @test_fields
    :ok
  end

  test "SSDPClient.discover returns something expected with defaults" do
    SSDPClient.discover()
    |> validate_discovered
  end

  test "discover allows specifying a time" do
    SSDPClient.discover(seconds: 1)
    |> validate_discovered
  end

  test "discover of custom weird search returns no results" do
    SSDPClient.discover(target: "foobarbaz:thisshouldnotbefound", seconds: 1)
    |> validate_discovered
  end

  # superlame test right now to make sure we can do count on the result
  # until we have a mock for a server this is the best we can do
  defp validate_discovered(discovered) do
    assert Enum.count(discovered)
    fields = discovered[@test_usn]
    assert fields
    Enum.each @test_fields, fn({k,v}) ->
      assert fields[k] == v
    end
  end
end
