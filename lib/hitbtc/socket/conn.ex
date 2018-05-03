defmodule Hitbtc.Socket.Conn do
  @moduledoc """
  HitBTC Websocket Connection client
  """

  use WebSockex
  require Logger

  @socket_uri "wss://api.hitbtc.com/api/2/ws"

  defmodule State do
    @moduledoc false

    @type t :: %__MODULE__{consumer_pid: pid | module}

    @enforce_keys [:consumer_pid]
    defstruct consumer_pid: nil
  end

  @doc """
  Opens new connection to HitBTC websocket

  Parameter is process that will receive all notifications from WS
  The `consumer_pid` of the process can be set using
  the `consumer_pid` argument and defaults to the calling process.
  """
  @spec open() :: {:ok, pid} | {:error, term}
  @spec open(GenServer.server()) :: {:ok, pid} | {:error, term}
  def open(consumer_pid \\ nil) do
    consumer_pid = consumer_pid || self()
    Process.monitor(consumer_pid)

    WebSockex.start_link(@socket_uri, __MODULE__, %State{consumer_pid: consumer_pid})
  end

  @doc """
  Send request to websocket
  """
  @spec request(pid, binary, binary | map) :: binary | {:error, term}
  def request(pid, method, params) do
    id = random_id()

    with {:ok, data} <- Poison.encode(%{method: method, params: params, id: id}),
         :ok <- WebSockex.send_frame(pid, {:text, data}) do
      id
    else
      err -> {:error, err}
    end
  end

  #
  # Callback functions
  #

  @doc false
  def handle_info({:DOWN, _ref, :process, _pid, reason}, _state), do: exit(reason)

  @doc false
  def handle_connect(conn, state), do: notify_consumer(state, {:connected, conn})

  @doc false
  def handle_frame({:text, msg}, state) when is_binary(msg) do
    case Poison.decode(msg, keys: :atoms) do
      {:ok, data} ->
        notify_consumer(state, {:frame, :response, data})

      {:error, _err} ->
        notify_consumer(state, {:frame, :text, msg})
    end
  end

  @doc false
  def handle_frame({type, msg}, state), do: notify_consumer(state, {:frame, type, msg})

  @doc false
  def handle_disconnect(%{reason: {:local, reason}}, state),
    do: notify_consumer(state, {:disconnected, reason})

  @doc false
  def handle_disconnect(disconnect_map, state), do: super(disconnect_map, state)

  #
  # Private functions
  #

  # Generate random id for request
  defp random_id(length \\ 12) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  # Send message to consumer
  defp notify_consumer(%State{consumer_pid: consumer_pid} = state, msg) do
    send(consumer_pid, msg)
    {:ok, state}
  end
end
