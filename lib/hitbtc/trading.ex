defmodule Hitbtc.Trading do

  alias Hitbtc.Util.Api

  @moduledoc """
  Set of trading API methods

  This set of methods requires auth information.
  You could configure it into `config.exs` file of your application
  """

  @doc """
  List of your current orders

  ## Example:

  ```elixir
  iex(1)> Hitbtc.Trading.order()
  {:ok,
    [%{clientOrderId: "fe423a1615d6429dafa6549780615155",
      createdAt: "2017-10-26T05:47:22.520Z", cumQuantity: "0.000",
      id: "4645665806", price: "1.000000", quantity: "0.050", side: "sell",
      status: "new", symbol: "ETHBTC", timeInForce: "GTC", type: "limit",
      updatedAt: "2017-10-26T05:47:22.520Z"}]}
  ```

  Or with specified symbol:
  ```elixir
  iex(10)> Hitbtc.Trading.order("BTGUSD")
  {:ok, []}
  ```

  In case of error function will return an error message:
  ```elixir
  iex(6)> Hitbtc.Trading.order("ETHADT")
  {:error,
    %{code: 2001,
      description: "Try get /api/2/public/symbol, to get list of all available symbols.",
      message: "Symbol not found"}}
  ```
  """
  @spec order(String.t) :: {:ok, [map]} | {:error, term}
  def order(symbol \\ ""), do: Api.get_body("/order", [symbol: symbol])

  @doc """
  Closes all orders.
  If symbol passed orders will be closed for given symbol only.

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Trading.close_all_ordes()
  {:ok,
    [%{clientOrderId: "fe423a1615d6429dafa6549780615155",
      createdAt: "2017-10-26T05:47:22.520Z", cumQuantity: "0.000",
      id: "4645665806", price: "1.000000", quantity: "0.050", side: "sell",
      status: "canceled", symbol: "ETHBTC", timeInForce: "GTC", type: "limit",
      updatedAt: "2017-11-07T12:02:41.518Z"}]}
  ```
  """
  @spec cancel_all_orders(String.t) :: {:ok, [map]} | {:error, term}
  def cancel_all_orders(symbol \\ ""), do: Api.delete_body("/order", [symbol: symbol])

  @doc """
  Load details of your order

  ## Example

  ```elixir
  iex(1)> Hitbtc.Trading.get_order("fe423a1615d6429dafa6549780615155")
  {:ok,
    %{clientOrderId: "fe423a1615d6429dafa6549780615155",
      createdAt: "2017-10-26T05:47:22.520Z", cumQuantity: "0.000",
      id: "4645665806", price: "1.000000", quantity: "0.050", side: "sell",
      status: "new", symbol: "ETHBTC", timeInForce: "GTC", type: "limit",
      updatedAt: "2017-10-26T05:47:22.520Z"}}
  ```

  Or error if something wrong with order:
  ```elixir
  iex(1)> Hitbtc.Trading.get_order("fe423a1615d6429dafa654978061515")
  {:error, %{code: 20002, description: "", message: "Order not found"}}
  ```
  """
  @spec get_order(String.t) :: {:ok, map} | {:error, term}
  def get_order(clientOrderId), do: Api.get_body("/order/#{clientOrderId}")

  @doc """
  Close order with given clientOrderId

  ## Example:
  ```elixir

  ```
  
  Or with non existing order
  ```elixir
  iex(1)> Hitbtc.Trading.cancel_order("fe423a1615d6429dafa6549780615155")
  {:error, %{code: 20002, description: "", message: "Order not found"}}
  ```
  """
  @spec cancel_order(String.t) :: {:ok, map} | {:error, term}
  def cancel_order(clientOrderId), do: Api.delete_body("/order/#{clientOrderId}")

  @doc """
  Get list of your trading balance

  ## Example
  ```elixir
  iex(1)> Hitbtc.Trading.trading_balance
  {:ok,
    [%{available: "0", currency: "1ST", reserved: "0"},
     %{available: "0", currency: "8BT", reserved: "0"},
     %{available: "0", currency: "ADX", reserved: "0"},
     %{available: "0", currency: "DASH", reserved: "0"},
     %{available: "0", currency: "DCN", reserved: "0"},
     %{available: "0", currency: "DCT", reserved: "0"},
     %{available: "0", currency: "DDF", reserved: "0"},
     %{available: "0", currency: "DLT", ...}, %{available: "0", ...}, %{...}, ...]}
  ```
  """
  @spec trading_balance() :: {:ok, [map]} | {:error, term}
  def trading_balance, do: Api.get_body("/trading/balance")

  @doc """
  Get trading fee for given symbol

  ## Example
  ```elixir
  iex(1)> Hitbtc.Trading.trading_fee("ETHBTC")
  {:ok, %{provideLiquidityRate: "-0.0001", takeLiquidityRate: "0.001"}}
  ```
  """
  @spec trading_fee(String.t) :: {:ok, map} | {:error, term}
  def trading_fee(symbol), do: Api.get_body("/trading/fee/#{symbol}")

end
