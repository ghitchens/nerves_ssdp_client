# Nerves.SSDPClient

**This is a very, very simple client for SSDP**

SSDP stands for the [Simple Service Discovery Protocol](https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol),
which is device and service discovery protocol built on top of [HTTPU](https://en.wikipedia.org/wiki/HTTPU).

Part of the [Nerves framework](http://nerves-project.org), but can be also used standalone.
The only dependency is [Elixir](http://elixir-lang.org).

## Usage

Super Simple.   Just invoke one funciton:

```elixir
nodes = Nerves.SSDPClient.discover
```

See docs for `SSDPClient.discover` for optional parameters which will likely be
useful.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add nerves_ssdp_client to your list of dependencies in `mix.exs`:

```
def deps do
  [{:nerves_ssdp_client, "~> 0.1.0"}]
end
```

  2. Ensure nerves_ssdp_client is started before your application:

```
def application do
  [extra_applications: [:nerves_ssdp_client]]
end
```

