# COMP 4958 Assignment 2
# Richard Le - SET 3V - A01080411

defmodule Weather.Core do
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


