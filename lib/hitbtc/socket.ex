defmodule Hitbtc.Socket do
  use WebSockex
  require Logger

  @socket_uri "wss://api.hitbtc.com/api/2/ws"

  defmodule State do
    @moduledoc false

    @type t :: %__MODULE__{pKey: binary, sKey: binary}

    defstruct pKey: "", sKey: ""
  end

  def start_link() do
    WebSockex.start_link(@socket_uri, __MODULE__, %State{})
  end

  def handle_connect(_conn, state) do
    Logger.debug("#{__MODULE__}: Connected to HitBTC websocket")
    {:ok, state}
  end

  def handle_frame({type, msg}, state) do
    Logger.debug("Received Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
    {:ok, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.debug("Local close with reason: #{inspect(reason)}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end

  #
  # Client functions
  #

  @spec request(pid, binary, binary | map) :: binary | {:error, term}
  def request(pid, method, params) do
    id = random_id()
    data =
      %{method: method, params: params, id: id}
      |> Poison.encode!()

    :ok =
      pid
      |> WebSockex.send_frame({:text, data})

    id
  end

  # Generate random id for request
  defp random_id(length \\ 12) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
