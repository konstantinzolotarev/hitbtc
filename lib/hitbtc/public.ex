defmodule Hitbtc.Public do

  alias Hitbtc.Util.Api

  @moduledoc """
  Public API's for HitBtc API v2
  """

  @doc """
  Get list of avialable Symbols (Currency Pairs). You can read more info at http://www.investopedia.com/terms/c/currencypair.asp

  ## Example:

  ```elixir
  iex(1)> Hitbtc.Public.symbol_list
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
  """
  @spec symbol_list() :: {:ok, [map]} | {:error, term}
  def symbol_list, do: Api.get_body("/public/symbol")

  @doc """
  Get symbol info

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.symbol("ETHBTC")
  {:ok,
    %{baseCurrency: "ETH", feeCurrency: "BTC", id: "ETHBTC",
      provideLiquidityRate: "-0.0001", quantityIncrement: "0.001",
      quoteCurrency: "BTC", takeLiquidityRate: "0.001", tickSize: "0.000001"}}
  ```

  Or with wrong symbol
  ```elixir
  iex(1)> Hitbtc.Public.symbol("ETHBT")
  {:error,
    %{code: 2001,
      description: "Try get /api/2/public/symbol, to get list of all available symbols.",
      message: "Symbol not found"}}
  ```
  """
  @spec symbol(String.t) :: {:ok, map} | {:error, term}
  def symbol(symbol), do: Api.get_body("/public/symbol/#{symbol}")

  @doc """
  Loads list of available currencies

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.currency
  {:ok,
    [%{crypto: true, fullName: "First Blood", id: "1ST", payinConfirmations: 2,
      payinEnabled: true, payinPaymentId: false, payoutEnabled: true,
      payoutIsPaymentId: true, transferEnabled: true},
     %{crypto: false, fullName: "The 8 Circuit Studios Token", id: "8BT",
       payinConfirmations: 2, payinEnabled: false, payinPaymentId: false,
       payoutEnabled: false, payoutIsPaymentId: false, transferEnabled: true},
     %{crypto: true, fullName: "DigixDAO", ...}, %{crypto: true, ...}, %{...},
     ...]}
  ```
  """
  @spec currency() :: {:ok, [map]} | {:error, term}
  def currency, do: Api.get_body("/public/currency")

  @doc """
  Get currency info

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.currency("ADX")
  {:ok,
    %{crypto: true, fullName: "AdEx", id: "ADX", payinConfirmations: 2,
      payinEnabled: true, payinPaymentId: false, payoutEnabled: true,
      payoutIsPaymentId: false, transferEnabled: true}}
  ```

  Or with wrong currency it will return error:

  ```elixir
  iex(1)> Hitbtc.Public.currency("AD")
  {:error, %{code: 2002, description: "", message: "Currency not found"}}
  ```
  """
  @spec currency(String.t) :: {:ok, map} | {:error, term}
  def currency(currency), do: Api.get_body("/public/currency/#{currency}")

  @doc """
  The Ticker endpoint returns last 24H information about of all symbol.

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.ticker
  {:ok,
    [%{ask: "0.0000002557", bid: "0.0000002546", high: "0.0000002738",
      last: "0.0000002551", low: "0.0000002510", open: "0.0000002663",
      symbol: "BCNBTC", timestamp: "2017-10-20T12:43:10.541Z",
      volume: "1811898700", volumeQuote: "468.04424347"},
     %{ask: "4499.99", bid: "2005.15", high: "4500.00", last: "4499.98",
       low: "2005.00", open: "3866.00", symbol: "BTCEUR",
       timestamp: "2017-10-20T12:43:00.080Z", volume: "0.31",
       volumeQuote: "1041.3065"},
     %{ask: "0.000167", bid: "0.000160", high: "0.000168", ...},
     %{ask: "0.000084", bid: "0.000081", ...}, %{ask: "0.000320", ...}, %{...},
     ...]}
  ```
  """
  @spec ticker() :: {:ok, [map]} | {:error, term}
  def ticker, do: Api.get_body("/public/ticker")

  @doc """
  The Ticker endpoint returns last 24H information about symbol.

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.ticker("BCNBTC")
  {:ok,
    %{ask: "0.0000002547", bid: "0.0000002538", high: "0.0000002738",
      last: "0.0000002538", low: "0.0000002510", open: "0.0000002607",
      symbol: "BCNBTC", timestamp: "2017-10-20T12:50:36.967Z",
      volume: "1806289600", volumeQuote: "466.54254156"}}
  ```

  Or will return error for non existing symbol

  ```elixir
  iex(1)> Hitbtc.Public.ticker("BCNBT")
  {:error,
    %{code: 2001,
      description: "Try get /api/2/public/symbol, to get list of all available symbols.",
      message: "Symbol not found"}}
  ```
  """
  @spec ticker(String.t) :: {:ok, map} | {:error, term}
  def ticker(symbol), do: Api.get_body("/public/ticker/#{symbol}")

  @doc """
  Load list of trade orders for symbol (currency pair)

  List of available params:
    
   - `sort` - Sort direction: `ASC`, `DESC`
   - `by` - Filter field. Values: `timestamp`, `id`
   - `from` - If filter by timestamp, then datetime in iso format or timestamp in millisecond otherwise trade id
   - `till` - If filter by timestamp, then datetime in iso format or timestamp in millisecond otherwise trade id
   - `limit` - Limit
   - `offset` - Offset

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.trades("ETHBTC")
  {:ok,
    [
      %{id: 55085930, price: "0.054067", quantity: "1.348", side: "sell",
        timestamp: "2017-10-20T13:36:58.326Z"},
      %{id: 55085900, price: "0.054065", quantity: "12.643", side: "buy",
        timestamp: "2017-10-20T13:36:54.127Z"},
      %{id: 55083603, price: "0.054084", ...}, %{id: 55083594, ...}, %{...}, ...
    ]
  }
  ```

  ## With params

  ```elixir
  iex(5)> Hitbtc.Public.trades("ETHBTC", [by: "timestamp", limit: 2, offset: 2])
  {:ok,
    [%{id: 55110010, price: "0.053644", quantity: "0.072", side: "buy",
      timestamp: "2017-10-20T14:26:43.944Z"},
     %{id: 55110008, price: "0.053644", quantity: "0.261", side: "buy",
       timestamp: "2017-10-20T14:26:43.926Z"}]}
  ```

  Or error if non existing symbol

  ```elixir
  iex(1)> Hitbtc.Public.trades("ETHBT")
  {:error,
    %{code: 2001,
      description: "Try get /api/2/public/symbol, to get list of all available symbols.",
      message: "Symbol not found"}}
  ```
  """
  @spec trades(String.t, [tuple]) :: {:ok, [map]} | {:error, term}
  def trades(symbol, params \\ []), do: Api.get_body("/public/trades/#{symbol}", params)

  @doc """
  Load order book

  ## Example
  
  ```elixir
  iex(1)> Hitbtc.Public.order_book("ETHBTC")
  {:ok,
    %{ask: [%{price: "0.053810", size: "4.288"},
            %{price: "0.053827", size: "35.000"}, %{price: "0.053828", size: "5.233"},
            %{price: "0.053834", size: "5.120"}, %{price: "0.053889", size: "67.811"},
            %{price: "0.053891", size: "6.000"}, %{price: "0.053900", size: "0.388"},
            %{price: "0.053971", size: "0.215"}, %{price: "0.053972", size: "0.100"},
            %{price: "0.053446", size: "0.001"}, %{price: "0.053398", size: "42.000"},
            %{price: "0.053395", size: "52.000"}, %{price: "0.053394", ...}, %{...},
            ...]}}
  ```

  Load list of orders with limit

  ```elixir
  iex(1)> Hitbtc.Public.order_book("ETHBTC", 2)
  {:ok,
    %{ask: [%{price: "0.053848", size: "7.038"},
            %{price: "0.053849", size: "0.975"}],
      bid: [%{price: "0.053805", size: "0.388"},
            %{price: "0.053800", size: "0.597"}]}}
  ```
  """
  @spec order_book(String.t, integer) :: {:ok, [map]} | {:error, term}
  def order_book(symbol, limit \\ 100), do: Api.get_body("/public/orderbook/#{symbol}", [limit: limit]) 

  @doc """
  Load candles for symbol

  Available params:
   
   - `limit` - Limit. Example: 100
   - `period` - `Period to load. Values: `M1`, `M3`, `M5`, `M15`, `M30`, `H1`, `H4`, `D1`, `D7`, `1M`

  ## Example

  ```elixir
  iex(1)> Hitbtc.Public.candles("ETHBTC", [limit: 2])
  {:ok,
    [%{close: "0.053640", max: "0.054078", min: "0.053640", open: "0.054006",
      timestamp: "2017-10-20T14:00:00.000Z", volume: "509.362",
      volumeQuote: "27.450554472"},
     %{close: "0.053343", max: "0.053598", min: "0.053157", open: "0.053598",
       timestamp: "2017-10-20T14:30:00.000Z", volume: "219.951",
       volumeQuote: "11.721044320"}]}
  ```
  """
  @spec candles(String.t, [tuple]) :: {:ok, [map]} | {:error, term}
  def candles(symbol, params \\ []), do: Api.get_body("/public/candles/#{symbol}", params)
end
