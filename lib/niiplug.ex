defmodule Niiplug.API do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [worker(Niiplug.Web, [])]
    opts = [strategy: :one_for_one, name: Niiplug.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Niiplug.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    case Plug.Adapters.Cowboy.http Niiplug.Web, [] do
      {:ok, res} ->
        IO.puts "Starting server"
        {:ok, res}
      {:error, err} ->
        IO.puts err
        {:error, err}
    end
  end

  get "/" do
    conn
    |> send_resp(200, "ok")
    |> halt
  end

  match _ do
    conn
    |> send_resp(404, "Nothing here")
    |> halt
  end
end
