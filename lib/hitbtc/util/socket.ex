defmodule Hitbtc.Util.Socket do
  @moduledoc """
  Default socket wrapper for HitBTC api
  """
  use GenServer

  @uri "wss://api.hitbtc.com/api/2/ws"

  defmodule State do
    @moduledoc """
    Default state for Socket connection
    """
    @type t :: %__MODULE__{algo: binary, pKey: binary, sKey: binary, nonce: binary, signature: binary}

    @enforce_keys [:pKey] 
    defstruct socket: nil, algo: "BASIC", pKey: "", sKey: "", nonce: "", signature: ""  
  end

  @spec start_link() :: {:ok, pid} | {:error, term}
  @spec start_link([atom: binary]) :: {:ok, pid} | {:error, term}
  def start_link(params \\ [], opts \\ []) do
    pKey = Keyword.get(params, :pKey, "")
    sKey = Keyword.get(params, :sKey, "")
    GenServer.start_link(__MODULE__, %State{pKey: pKey, sKey: sKey}, opts)
  end

  @doc false
  def init(state) do
    socket = start_socket()
    {:ok, %State{state | socket: socket}}
  end

  #
  # Callback functions
  #

  #
  # Public functions
  #

  #
  # Private functions
  #

  defp start_socket() do
    
  end
  
end
