defmodule Nerves.SSDPClient do

  @moduledoc """
  Implements a simple discovery client for SSDP, not the full UPNP spec.
  - Supports M-SEARCH and gathering unicast responses.
  - Does not support prolonged listens and gathered notifies at this time.
  """

  @default_target  "ssdp:all"
  @default_seconds 2
  @default_slack   250

  @doc false
  def start(_type, _args) do
    {:ok, self()}
  end

  @doc """
  Issue an SSDP "M-SEARCH" request to the network, and listen for a bit for
  responses, reporting back discovered nodes in a hash.

  Parameters is Dict with the following defined keyword atoms:

  `target` - the search target, as defined by the ssdp spec.  Defaults to "ssdp:all"

  `seconds` -  sent with the search request to tell nodes how long they have to
  respond.  Defaults to 2.

  `slack` - Number of milliseconds to wait __after__ the seconds parameter for responses.
  Defaults to 250, but can be set higher for high-latency networks
  """

  def discover(params \\ []) do
    target = Dict.get params, :target, @default_target
    seconds = Dict.get params, :seconds, @default_seconds
    slack_ms = Dict.get params, :slack, @default_slack
    timeout_ms = (seconds * 1000) + slack_ms
    message = search_msg(target, seconds)
    {:ok, socket} = :gen_udp.open(0, [{:reuseaddr, true}])
    :gen_udp.send(socket, {239, 255, 255, 250}, 1900, message)
    Process.send_after self(), :timeout, timeout_ms
    gather_responses_until_timeout(%{}, socket)
  end

  defp gather_responses_until_timeout(gathered, socket) do
    receive do
      {:udp, socket, host, _port, msg} ->
        gathered
        |> Dict.merge(decoded_response(host, msg))
        |> gather_responses_until_timeout(socket)
      :timeout ->
        :gen_udp.close(socket)
        gathered
    end
  end

  # returns a dict with usn as key, like [usn: %{host: ..., ...., ...}]
  defp decoded_response(host, msg) do
    a_host =
      host
      |> :inet.ntoa
      |> :erlang.list_to_binary
    msg
    |> :erlang.list_to_binary
    |> decode_ssdp_packet
    |> Dict.merge(host: a_host)
    |> keyed_by_usn
  end

  # returns a dict where key is usn, and value is rest of dict
  defp keyed_by_usn(dict) do
    [Dict.pop(dict, :usn)]
  end

  # returns keys/values given an ssdp packet
  defp decode_ssdp_packet(packet) do
    {[_raw_http_line], raw_params} =
      packet
      |> String.split(["\r\n", "\n"])
      |> Enum.split(1)
    #http_line = String.downcase(raw_http_line) |> String.strip
    #{[http_verb, {full_uri], _rest} = String.split(http_line) |> Enum.split(2)
    mapped_params = Enum.map raw_params, fn(x) ->
      case String.split(x, ":", parts: 2) do
        [k, v] -> {String.to_atom(String.downcase(k)), String.strip(v)}
        _ -> nil
      end
    end
    resp = Enum.reject mapped_params, &(&1 == nil)
    Dict.merge(%{}, resp) # convert to map, REVIEW better way?
  end

  defp search_msg(search_target, max_seconds) do
    "M-SEARCH * HTTP/1.1\r\n" <>
    "Host: 239.255.255.250:1900\r\n" <>
    "MAN: \"ssdp:discover\"\r\n" <>
    "ST: #{search_target}\r\nMX: #{max_seconds}\r\n\r\n"
  end

end
