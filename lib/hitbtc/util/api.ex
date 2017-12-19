defmodule Hitbtc.Util.Api do
  @moduledoc false

  use HTTPoison.Base

  @host Application.get_env(:hitbtc, :api_url, "https://api.hitbtc.com/api/2")
  @timeout Application.get_env(:hitbtc, :request_timeout, 8000)
  @apiKey Application.get_env(:hitbtc, :api_key, "")
  @apiSecret Application.get_env(:hitbtc, :api_secret, "")

  def host, do: @host
  def process_url(url), do: @host <> url

  defp process_request_options([]), do: [timeout: @timeout]
  defp process_request_options([timeout: _t] = opts), do: opts
  defp process_request_options(opts), do: Keyword.merge(opts, [timeout: @timeout])

  defp process_response_body(""), do: ""
  defp process_response_body(body) do
    body
    |> Poison.decode!(keys: :atoms)
  end

  @doc """
  Fetch only actual body from request with specified params
  """
  @spec get_body(String.t, [tuple]) :: {:ok, any} | {:error, any}
  def get_body(url, params \\ []), do: get(url, %{}, options(params)) |> fetch_body() |> pick_data()

  @doc """
  Fetch only actual body from POST request to API server
  """
  @spec post_body(String.t, [tuple], [tuple]) :: {:ok, any} | {:error, any}
  def post_body(url, body, params \\ []) do
    params = params ++ ["Content-type": "application/x-www-form-urlencoded"]
    post(url, {:form, body}, [], options(params))
    |> fetch_body()
    |> pick_data()
  end

  @doc """
  Fetch only an actual body from PUT request to API server
  """
  @spec put_body(String.t, map, [tuple]) :: {:ok, any} | {:error, any}
  def put_body(url, body, params \\ []) do
    put(url, body, [], options(params))
    |> fetch_body()
    |> pick_data()
  end

  @doc """
  Fethc only actual body form PATCH request to API server
  """
  @spec patch_body(String.t, map, [tuple]) :: {:ok, any} | {:error, any}
  def patch_body(url, body, params \\ []) do
    patch(url, body, [], options(params))
    |> fetch_body()
    |> pick_data()
  end
  @doc """
  Fetch only actual body from DELETE request to server
  """
  @spec delete_body(String.t, [tuple]) :: {:ok, any} | {:error, any}
  def delete_body(url, params \\ []), do: delete(url, [], options(params)) |> fetch_body() |> pick_data()

  # Merge options with basic auth (if set in options)
  defp options(params) do
    opts = [
      params: params
    ] 

    with true <- String.length(@apiKey) > 0,
         true <- String.length(@apiSecret) > 0
    do opts ++ [hackney: [basic_auth: {@apiKey, @apiSecret}]]
    else 
      _ -> opts
    end
  end

  defp fetch_body({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body}
  defp fetch_body({:ok, %HTTPoison.Response{status_code: 201, body: body}}), do: {:ok, body}
  defp fetch_body({:ok, %HTTPoison.Response{body: %{error: error}}}), do: {:error, error}
  defp fetch_body({:error, err}), do: {:error, err}
  defp fetch_body(_), do: {:error, "Something wrong !"}

  # defp pick_data({:ok, %{Response: "Success", Data: data}}), do: {:ok, data}
  # defp pick_data({:ok, %{Response: "Error"} = data}), do: {:error, data}
  defp pick_data(resp), do: resp
end
