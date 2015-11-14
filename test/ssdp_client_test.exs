defmodule Nerves.SSDPClientTest do
  alias Nerves.SSDPClient
  use ExUnit.Case, async: true

  doctest SSDPClient

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
    discovered
  end
end
