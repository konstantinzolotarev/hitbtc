defmodule Hitbtc.Socket do
  alias Hitbtc.Socket.Conn

  @type request_id :: binary

  @doc """
  Open new Websocket connection to HitBTC server

  Parameter is process that will receive all notifications from WS
  The `consumer_pid` of the process can be set using
  the `consumer_pid` argument and defaults to the calling process.
  """
  @spec open() :: {:ok, pid} | {:error, term}
  @spec open(pid) :: {:ok, pid} | {:error, term}
  def open(consumer_pid \\ nil), do: Conn.open(consumer_pid)

  @doc """
  Send login request to HitBTC

  Example: 

  ```elixir
  iex(1)> {:ok, pid} = Hitbtc.Socket.open
  {:ok, #PID<0.188.0>}
  iex(2)> Hitbtc.Socket.login(pid, "test", "test")
  "jghHemLxwTYA"
  ```
  """
  @spec login(pid, binary, binary) :: request_id | {:error, term}
  def login(pid, pKey, sKey),
    do: Conn.request(pid, "login", %{algo: "BASIC", pKey: pKey, sKey: sKey})

  @doc """
  Subscribe to ticker

  Example: 

  ```elixir
  iex(1)> {:ok, pid} = Hitbtc.Socket.open()
  {:ok, #PID<0.188.0>}
  iex(2)> Hitbtc.Socket.subscribe_ticker(pid, "BCHETH")
  "QBYspPaGj2sA"
  iex(3)> flush
  {:frame, :response, %{id: "QBYspPaGj2sA", jsonrpc: "2.0", result: true}}
  {:frame, :response,
    %{
      jsonrpc: "2.0",
      method: "ticker",
      params: %{
        ask: "2.042597",
        bid: "2.034390",
        high: "2.220977",
        last: "2.040262",
        low: "2.019090",
        open: "2.136375",
        symbol: "BCHETH",
        timestamp: "2018-05-03T13:01:37.580Z",
        volume: "733.48",
        volumeQuote: "1552.40983616"
      }
    }}
  ```
  """
  @spec subscribe_ticker(pid, binary) :: request_id | {:error, term}
  def subscribe_ticker(pid, symbol), do: Conn.request(pid, "subscribeTicker", %{symbol: symbol})

  @doc """
  Unsubscribe from ticker for symbol

  Example:

  ```elixir
  iex(1)> {:ok, pid} = Hitbtc.Socket.open
  {:ok, #PID<0.188.0>}
  iex(2)> Hitbtc.Socket.subscribe_ticker(pid, "BCHETH")
  "2gLFWInOKgSy"
  iex(3)> Hitbtc.Socket.unsubscribe_ticker(pid, "BCHETH")
  "aCbL4oiPQ0AX"
  iex(4)> flush
  {:frame, :response, %{id: "2gLFWInOKgSy", jsonrpc: "2.0", result: true}}
  {:frame, :response,
    %{
      jsonrpc: "2.0",
      method: "ticker",
      params: %{
        ask: "2.028765",
        bid: "2.021214",
        high: "2.220977",
        last: "2.027251",
        low: "2.019090",
        open: "2.138210",
        symbol: "BCHETH",
        timestamp: "2018-05-03T13:06:04.531Z",
        volume: "730.40",
        volumeQuote: "1545.68635928"
      }
    }}
  {:frame, :response, %{id: "aCbL4oiPQ0AX", jsonrpc: "2.0", result: true}}
  :ok
  ```
  """
  @spec unsubscribe_ticker(pid, binary) :: request_id | {:error, term}
  def unsubscribe_ticker(pid, symbol),
    do: Conn.request(pid, "unsubscribeTicker", %{symbol: symbol})

  @doc """
  Subscribe to orders for symbol

  Example: 

  ```elixir 
  iex> {:ok, pid} = Hitbtc.Socket.open
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
  """
  @spec subscribe_orderbook(pid, binary) :: request_id | {:error, term}
  def subscribe_orderbook(pid, symbol),
    do: Conn.request(pid, "subscribeOrderbook", %{symbol: symbol})

  @doc """
  Unsubscribe from orderbook for symbol

  Example:

  ```elixir 
  iex> {:ok, pid} = Hitbtc.Socket.open
  {:ok, #PID<0.188.0>}
  iex> Hitbtc.Socket.subscribe_orderbook(pid, "BCHETH")
  "La3I7JKC3JkJ"
  iex> Hitbtc.Socket.unsubscribe_orderbook(pid, "BCHETH")
  "t4xGn6mIDdU1"
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
  {:frame, :response, %{id: "t4xGn6mIDdU1", jsonrpc: "2.0", result: true}}
  :ok
  ```
  """
  @spec unsubscribe_orderbook(pid, binary) :: request_id | {:error, term}
  def unsubscribe_orderbook(pid, symbol),
    do: Conn.request(pid, "unsubscribeOrderbook", %{symbol: symbol})

  @doc """
  Subscribe to trades for symbol

  Example:

  ```elixir
  iex> Hitbtc.Socket.subscribe_trades(pid, "BCHETH")
  "f4vONb_htaii"
  iex> flush
  {:frame, :response, %{id: "f4vONb_htaii", jsonrpc: "2.0", result: true}}
  {:frame, :response,
    %{
      jsonrpc: "2.0",
      method: "snapshotTrades",
      params: %{
        data: [
          %{
            id: 282166637,
            price: "2.122786",
            quantity: "0.05",
            side: "buy",
            timestamp: "2018-05-02T23:30:09.053Z"
          },
          %{id: 282176290, price: "2.119886", quantity: "0.01", side: "sell", ...},
          %{id: 282176310, price: "2.121108", quantity: "0.10", ...},
          %{id: 282176615, price: "2.118504", ...},
          %{id: 282176715, ...},
          %{...},
          ...
        ],
        symbol: "BCHETH"
      }
    }}
  :ok
  ```
  """
  @spec subscribe_trades(pid, binary) :: request_id | {:error, term}
  def subscribe_trades(pid, symbol), do: Conn.request(pid, "subscribeTrades", %{symbol: symbol})

  @doc """
  Unsubscribe from trades for symbol

  Example:

  ```elixir
  iex> Hitbtc.Socket.subscribe_trades(pid, "BCHETH")
  "f4vONb_htaii"
  iex> Hitbtc.Socket.unsubscribe_trades(pid, "BCHETH")
  "2imaJqNUCbfW"
  iex> flush
  {:frame, :response, %{id: "f4vONb_htaii", jsonrpc: "2.0", result: true}}
  {:frame, :response,
    %{
      jsonrpc: "2.0",
      method: "snapshotTrades",
      params: %{
        data: [
          %{
            id: 282166637,
            price: "2.122786",
            quantity: "0.05",
            side: "buy",
            timestamp: "2018-05-02T23:30:09.053Z"
          },
          %{id: 282176290, price: "2.119886", quantity: "0.01", side: "sell", ...},
          %{id: 282176310, price: "2.121108", quantity: "0.10", ...},
          %{id: 282176615, price: "2.118504", ...},
          %{id: 282176715, ...},
          %{...},
          ...
        ],
        symbol: "BCHETH"
      }
    }}
  {:frame, :response, %{id: "2imaJqNUCbfW", jsonrpc: "2.0", result: true}}
  :ok
  ```
  """
  @spec unsubscribe_trades(pid, binary) :: request_id | {:error, term}
  def unsubscribe_trades(pid, symbol),
    do: Conn.request(pid, "unsubscribeTrades", %{symbol: symbol})

  @doc """
  Subscribe to candles for symbol + period

  Example:

  ```elixir
  iex> Hitbtc.Socket.subscribe_candles(pid, "BCHETH", "M30")
  "qZJ_-6CqjIvV"
  iex> flush
  {:frame, :response, %{id: "qZJ_-6CqjIvV", jsonrpc: "2.0", result: true}}
  {:frame, :response,
    %{
      jsonrpc: "2.0",
      method: "snapshotCandles",
      params: %{
        data: [
          %{
            close: "1.754573",
            max: "1.780656",
            min: "1.711121",
            open: "1.714521",
            timestamp: "2018-04-03T13:00:00.000Z",
            volume: "125.36",
            volumeQuote: "219.62493994"
          },
          %{close: "1.701630", max: "1.706478", min: "1.699430", ...},
          %{close: "1.697734", max: "1.706294", ...},
          %{close: "1.708355", ...},
          %{...},
          ...
        ],
        period: "M30",
        symbol: "BCHETH"
      }
    }}
  :ok
  ```
  """
  @spec subscribe_candles(pid, binary, binary) :: request_id | {:error, term}
  def subscribe_candles(pid, symbol, period \\ "M30"),
    do: Conn.request(pid, "subscribeCandles", %{symbol: symbol, period: period})

  @doc """
  Unsubscribe from candles for symbol + period

  Example:

  ```elixir
  iex> Hitbtc.Socket.unsubscribe_candles(pid, "BCHETH", "M30")
  "509GAmNnJzwY"
  iex(8)> flush
  {:frame, :response, %{id: "509GAmNnJzwY", jsonrpc: "2.0", result: true}}
  :ok
  ```
  """
  @spec unsubscribe_candles(pid, binary, binary) :: request_id | {:error, term}
  def unsubscribe_candles(pid, symbol, period \\ "M30"),
    do: Conn.request(pid, "unsubscribeCandles", %{symbol: symbol, period: period})


  @doc """
  Subscribe to all system reports.

  **Require authorization**

  Notification with active orders send after subscription or on any service maintain

  Example: 

  ```elixir
  iex(1)> {:ok, pid} = Hitbtc.Socket.open
  {:ok, #PID<0.188.0>}
  iex(2)> Hitbtc.Socket.subscribe_reports(pid)
  "k8CrqluaD6EW"
  iex(3)> flush
  {:frame, :response,
    %{
      error: %{code: 1001, description: "", message: "Authorization required"},
      id: "k8CrqluaD6EW",
      jsonrpc: "2.0"
    }}
  :ok
  ```
  """
  @spec subscribe_reports(pid) :: request_id | {:error, term}
  def subscribe_reports(pid),
    do: Conn.request(pid, "subscribeReports", %{})
end
