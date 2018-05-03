# HitBTC Elixir API [![Hex pm](http://img.shields.io/hexpm/v/hitbtc.svg?style=flat)](https://hex.pm/packages/hitbtc) [![hex.pm downloads](https://img.shields.io/hexpm/dt/hitbtc.svg?style=flat)](https://hex.pm/packages/hitbtc)

HitBTC REST API V2 / Socket for Elixir.

[Documentation](https://hexdocs.pm/hitbtc/api-reference.html) available on hex.pm

## Installation

First add `hitbtc` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:hitbtc, "~> 0.2.0"}
  ]
end
```

Then run `$ mix deps.get`.

For Elixir below version `1.3` add `:hitbtc` to your applications list.

```elixir
def application do
  [applications: [:hitbtc]]
end
```

## Configuration

There are no lot of configuration options. For now only `request_timeout` option is available.
It will set default timeout for reply from HitBTC API. By default it set to `8` seconds

And your API keys also should be configured to use "private" APIs like `Hitbtc.Http.Trading` and `Hitbtc.Http.Account`
**If you will use only public APIs no need to configure API keys**

You could change it using your application `config.exs`:

```elixir
use Mix.Config

config :hitbtc, request_timeout: 10_000

config :hitbtc, api_key: "api-key-here"
config :hitbtc, api_secret: "api-secret-here"
```

## HTTP vs Socket API's

Client contain 2 methods of communication with HitBTC.

## Usage

Client contain set of actions for public usage (non account related).
And this actions could be used without auth config.

All public action are into `Hitbtc.Http.Public`. All other methods require auth configuration.

Usage example:

```elixir
iex(1)> Hitbtc.Http.Public.symbol_list
{:ok,
  [%{baseCurrency: "BCN", feeCurrency: "BTC", id: "BCNBTC",
    provideLiquidityRate: "-0.0001", quantityIncrement: "100",
    quoteCurrency: "BTC", takeLiquidityRate: "0.001", tickSize: "0.0000000001"},
   %{baseCurrency: "BTC", feeCurrency: "EUR", id: "BTCEUR",
     provideLiquidityRate: "-0.0001", quantityIncrement: "0.01",
     quoteCurrency: "EUR", takeLiquidityRate: "0.001", tickSize: "0.01"},
   %{baseCurrency: "DCT", feeCurrency: "BTC", ...}, %{baseCurrency: "ANT", ...},
   %{...}, ...]}
```

## Socket client

Socket client is a process that handle communication and send messages

Initialize connection using `Hitbtc.Socket.open()`

Example:

```elixir
iex> {:ok, pid} = Hitbtc.Socket.open(self())
{:ok, #PID<0.188.0>}
iex> Hitbtc.Socket.subscribe_orderbook(pid, "BCHETH")
"La3I7JKC3JkJ"
iex> flush
{:frame, :response, %{id: "La3I7JKC3JkJ", jsonrpc: "2.0", result: true}}
{:frame, :response,
  %{
    jsonrpc: "2.0",
    method: "snapshotOrderbook",
    params: %{
      ask: [
        %{price: "2.033071", size: "0.03"},
        %{price: "2.033072", size: "0.13"},
        %{price: "2.033237", size: "0.21"},
        ...
      ],
      bid: [
        %{price: "2.027210", size: "0.08"},
        %{price: "2.027209", size: "1.85"},
        %{price: "2.024906", size: "1.85"},
        ...
      ],
      sequence: 36635757,
      symbol: "BCHETH"
    }
  }}
{:frame, :response,
  %{
    jsonrpc: "2.0",
    method: "updateOrderbook",
    params: %{
      ask: [
        %{price: "2.036203", size: "0.00"},
        %{price: "2.037233", size: "0.92"}
      ],
      bid: [],
      sequence: 36635758,
      symbol: "BCHETH"
    }
  }}
:ok
```

## License

```
Copyright © 2017 Konstantin Zolotarev

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.
```
