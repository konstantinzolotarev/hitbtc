# HitBTC Elixir API [![Hex pm](http://img.shields.io/hexpm/v/hitbtc.svg?style=flat)](https://hex.pm/packages/hitbtc) [![hex.pm downloads](https://img.shields.io/hexpm/dt/hitbtc.svg?style=flat)](https://hex.pm/packages/hitbtc)

HitBTC REST API V2 for Elixir.

[Documentation](https://hexdocs.pm/hitbtc/api-reference.html) available on hex.pm

## Installation

First add `hitbtc` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:hitbtc, "~> 0.1.0"}
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

And your API keys also sh9ould be configured to use "private" APIs like `Hitbtc.Trading` and `Hitbtc.Account`
**If you will use only public APIs no need to configure API keys**

You could change it using your application `config.exs`:

```elixir
use Mix.Config

config :hitbtc, request_timeout: 10_000

config :hitbtc, api_key: "api-key-here"
config :hitbtc, api_secret: "api-secret-here"
```

## Usage

## License

```
Copyright © 2017 Konstantin Zolotarev

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.
```
