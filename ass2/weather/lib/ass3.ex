# COMP 4958 Assignment 2
# Richard Le - SET 3V - A01080411

defmodule Core do

  def readAPIKey() do
    File.read("apikey.txt") |> elem(1) |> String.replace("\n", "")
  end

  defp kelvinToCelcius(kelvin) do
    Float.to_string(Float.round(kelvin - 273.15, 2))
  end

  defp apiHeader(), do: "https://api.openweathermap.org/data/2.5/weather?q="
  
  def locationAPIQuery(location) do
    data = HTTPoison.get(apiHeader() <> location <> "&appid=" <> readAPIKey()) |> elem(1)
    body = JSON.decode(data.body) |> elem(1)
    code = body["cod"]
    if code == 200 do
      (location <> ": " <> 
      kelvinToCelcius(body["main"]["temp"]) <> "C, " <> 
      Integer.to_string(body["main"]["humidity"]) <> "% humidity, " <> 
      hd(body["weather"])["description"])
    else
      "Error getting weather info or " <> location
    end

  end

  def cityCountryAPIQuery(city, country) do
    data = HTTPoison.get(apiHeader() <> city <> "," <> country <> "&appid=" <> readAPIKey()) |> elem(1)
    body = JSON.decode(data.body) |> elem(1)
    code = body["cod"]
    if code == 200 do
      (city <> "," <> country <> ": " <> 
      kelvinToCelcius(body["main"]["temp"]) <> "C, " <> 
      Integer.to_string(body["main"]["humidity"]) <> "% humidity, " <> 
      hd(body["weather"])["description"])
    else
      "Error getting weather info or " <> city <> ", " <> country
    end
  end
 
end


defmodule Server do
  use GenServer

  # client API
  def start() do
    GenServer.start(__MODULE__, nil, name: Weather)
  end

  def data_for(location) do
    GenServer.call(Weather, {:location, location})
  end

  def data_for(city, country) do
    GenServer.call(Weather, {:location, city, country})
  end

  def stop() do
    GenServer.stop(Weather, :normal)
  end 

  # callbacks
  def init(_arg) do
    {:ok, nil}
  end 

  def handle_call({:location, key}, _from, state) do
    {:reply, Core.locationAPIQuery(key), state}
  end

  def handle_call({:location, city, country}, _from, state) do
    {:reply, Core.cityCountryAPIQuery(city, country), state}
  end

end
