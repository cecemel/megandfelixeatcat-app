defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  match "/postal-addresses/*path" do
    Proxy.forward conn, path, "http://resource/postal-addresses/"
  end
  match "/food-establishments/*path" do
    Proxy.forward conn, path, "http://resource/food-establishments/"
  end
  match "/ratings/*path" do
    Proxy.forward conn, path, "http://resource/ratings/"
  end
  match "/aggregate-ratings/*path" do
    Proxy.forward conn, path, "http://resource/aggregate-ratings/"
  end
  match "/reviewers/*path" do
    Proxy.forward conn, path, "http://resource/reviewers/"
  end
  match "/reviews/*path" do
    Proxy.forward conn, path, "http://resource/reviews/"
  end
  match "/files/*path" do
    Proxy.forward conn, path, "http://resource/files/"
  end

 match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
