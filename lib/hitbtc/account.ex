defmodule Hitbtc.Account do

  alias Hitbtc.Util.Api

  @moduledoc """
  Set of account related action 

  This set of methods requires auth information.
  You could configure it into `config.exs` file of your application
  """

  @doc """
  Load list of your balance

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.balance
  {:ok,
    [%{available: "0.00000000", currency: "BTC", reserved: "0.00000000"},
     %{available: "0.00100000", currency: "BTG", reserved: "0.00000000"},
     %{available: "0.00000000", currency: "CLD", ...},
     %{available: "0.00000000", ...}, %{...}, ...]}
  ```
  """
  @spec balance() :: {:ok, [map]} | {:error, any}
  def balance(), do: Api.get_body("/account/balance")

  @doc """
  Get address for deposit currency

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.deposit_address_get("ETH")
  {:ok, %{address: "0xe2be99cf4d3b1ce48ae0f7c5f8a508be9b62d5e0"}}
  ```
  """
  @spec deposit_address_get(String.t) :: {:ok, map} | {:error, any}
  def deposit_address_get(currency), do: Api.get_body("/account/crypto/address/#{currency}")

  @doc """
  Create new address for deposit currency

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.deposit_address_new("BTG")
  {:ok, %{address: "GV2PQ4cmrC6zJZJQzfpLZze8D6KGM2piec"}}
  ```
  """
  @spec deposit_address_new(String.t) :: {:ok, map} | {:error, any}
  def deposit_address_new(currency), do: Api.post_body("/account/crypto/address/#{currency}", %{})

  @doc """
  Withdraw crypto

  **Note that this method might take long time.**
  Be carefull about timeout.

  This method support set of parameters:
   - `paymentId` - `String` 
   - `networkFee` - `Number` or `String` Too low and too high commission value will be rounded to valid values.
   - `includeFee` - `Boolean` Default false. If set true then total will be spent the specified amount, fee and networkFee will be deducted from the amount
   - `autoCommit` - `Boolean` Default true. If set false then you should commit or rollback transaction in an hour. Used in two phase commit schema.

  ## Example:
  ```elixir
  iex(5)> Hitbtc.Account.withdraw("ETH", 0.01, "0xe2be99cf4d3b1ce48ae0f7c5f8a508be9b62d5e0", [autoCommit: true])
  {:ok, %{id: "d2ce578f-647d-4fa0-b1aa-4a27e5ee597b"}}
  ```
  """
  @spec withdraw(String.t, float, String.t, [tuple]) :: {:ok, map} | {:error, any}
  def withdraw(currency, amount, address, params \\ []) do
    body = [
      currency: currency,
      amount: Float.to_string(amount),
      address: address
    ]
    Api.post_body("/account/crypto/withdraw", body ++ params)
  end

  @doc """
  Commit withdraw

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.withdraw_commit("d2ce578f-647d-4fa0-b1aa-4a27e5ee597b")
  {:ok, %{result: true}}
  ```
  """
  @spec withdraw_commit(String.t) :: {:ok, map} | {:error, any}
  def withdraw_commit(id), do: Api.put_body("/account/crypto/withdraw/#{id}", %{})

  @doc """
  Cancel withdraw

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.withdraw_cancel("d2ce578f-647d-4fa0-b1aa-4a27e5ee597b")
  {:ok, %{result: true}}
  ```
  """
  @spec withdraw_cancel(String.t) :: {:ok, map} | {:error, any}
  def withdraw_cancel(id), do: Api.delete_body("/account/crypto/withdraw/#{id}")

  @doc """
  Transfer money between trading and account
  Here before you are able to use your currency in trading you have to transfer it from your "bank" account to exchage.
  And before withdraw you have to transfer it vice versa

  This method has 3rd parameter `type` that indicated direction of transfer.
  And it might have this values:
   - `bankToExchange` - Transfer from bank to exchange 
   - `exchangeToBank` - Transfer from exchange to bank

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.transfer("ETH", 0.01, "bankToExchange")
  {:ok, %{id: "d2ce578f-647d-4fa0-b1aa-4a27e5ee597b"}}
  iex(2)> Hitbtc.Account.transfer("ETH", 0.01, "exchangeToBank")
  {:ok, %{id: "d2ce578f-647d-4fa0-b1aa-4a27e5ee597b"}}
  ```
  """
  @spec transfer(String.t, float, String.t) :: {:ok, map} | {:error, any}
  def transfer(currency, amount, type \\ "bankToExchange") do
    body = [
      currency: currency,
      amount: Float.to_string(amount),
      type: type
    ]
    Api.post_body("/account/transfer", body)
  end 

  @doc """
  Get transaction history 

  ## Example:
  ```elixir
  iex(1)> Hitbtc.Account.transaction_list
  {:ok,
    [%{amount: "0.00100000", createdAt: "2017-12-17T09:09:16.399Z",
      currency: "SBTC", id: "9289748d-2c1b-4a31-9a9c-e6bceda2b39d",
      index: 556153413, status: "success", type: "deposit",
      updatedAt: "2017-12-17T09:09:16.672Z"},
     %{amount: "0.050000000000000000", createdAt: "2017-10-26T05:46:21.883Z",
       currency: "ETH", id: "a484c7b6-6ccf-4c70-bfa8-251db3f0609b",
       index: 377464416, status: "success", type: "bankToExchange",
       updatedAt: "2017-10-26T05:46:26.404Z"},
     %{amount: "0.00100000", createdAt: "2017-10-26T05:46:09.363Z",
       currency: "BTC", id: "293a7efc-2b29-4262-8413-ca29b0b3b36b",
       index: 377462653, status: "success", type: "bankToExchange",
       updatedAt: "2017-10-26T05:46:10.799Z"}]}
  ```

  Or you could call it with transaction id:
  ```elixir
  iex(2)> Hitbtc.Account.transaction_list("9289748d-2c1b-4a31-9a9c-e6bceda2b39d")
  {:ok,
    %{amount: "0.00100000", createdAt: "2017-12-17T09:09:16.399Z",
      currency: "SBTC", id: "9289748d-2c1b-4a31-9a9c-e6bceda2b39d",
      index: 556153413, status: "success", type: "deposit",
      updatedAt: "2017-12-17T09:09:16.672Z"}}
  ```
  """
  @spec transaction_list(String.t, [tuple]) :: {:ok, [map]} | {:error, any}
  def transaction_list(id \\ "", params \\ []) do
    case id do
      "" -> Api.get_body("/account/transactions", params)
      str -> Api.get_body("/account/transactions/#{str}", params)
    end
  end

end
