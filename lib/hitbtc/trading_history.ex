defmodule Hitbtc.TradingHistory do

  alias Hitbtc.Util.Api

  @moduledoc """
  Set of Trading history methods

  This set of methods requires auth information.
  You could configure it into `config.exs` file of your application
  """

  @doc """
  List of all orders older then 24 hours without trades are deleted.

  Parameters:
   - `symbol` - `String` Optional parameter to filter active orders by symbol
   - `clientOrderId` - `String` If set, other parameters will be ignored. Without limit and pagination
   - `from` - `DateTime` 
   - `till` - `DateTime`
   - `limit` - `Number` Default set to 100
   - `offset` - `Number`

   ## Example:
  ```elixir
  iex(1)> Hitbtc.TradingHistory.order
  {:ok, []}
  ```

  Or you could provide different parameters:
  ```elixir
  iex(1)> Hitbtc.TradingHistory.order([symbol: "ETHBTC"])
  {:ok, []}
  ```
  """
  @spec order([tuple]) :: {:ok, [map]} | {:error, term}
  def order(params \\ []), do: Api.get_body("/history/order", params)

  @doc """
  Trades history

  Prameters: 
   - `symbol` - `String` Optional parameter to filter active orders by symbol
   - `sort` - `String` DESC or ASC. Default value DESC
   - `by` - `String` timestamp by default, or id
   - `from` - `DateTime`
   - `till` - `DateTime` 
   - `limit` - `Number` Default to 100
   - `offset` - `Number`

  ## Example:
  ```elixir
  iex(1)> Hitbtc.TradingHistory.trades
  {:ok, []}
  iex(2)> Hitbtc.TradingHistory.trades([symbol: "ETHBTC"])
  {:ok, []}
  ```
  """
  @spec trades([tuple]) :: {:ok, [map]} | {:error, term}
  def trades(params \\ []), do: Api.get_body("/history/trades", params)

  @doc """
  List of trades by order
  OrderId have to be provided

  ## Example:
  ```elixir
  iex(1)> Hitbtc.TradingHistory.order_trades("816088021")
  {:ok, []}
  ```
  """
  @spec order_trades(String.t) :: {:ok, [map]} | {:error, term}
  def order_trades(orderId), do: Api.get_body("/history/order/#{orderId}/trades")
end
