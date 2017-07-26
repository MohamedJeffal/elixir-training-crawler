defmodule ShopCrawler do
  use HTTPoison.Base


  @endpoint "https://httpbin.org"

  @expected_fields ~w(
    origin
    url
    headers
  )

  def process_url(url) do
     @endpoint <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({key, value}) -> {String.to_atom(key), value} end)
  end
end

defmodule RequestHelper do
  def easy_get(url) do
    ShopCrawler.start()
    ShopCrawler.get(url,  [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
  end
end


case RequestHelper.easy_get("/get") do
  {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    IO.inspect body
    IO.inspect body[:headers]["Host"]
  {:ok, %HTTPoison.Response{status_code: 404}} ->
    IO.puts "Element not found (404)"
  {:error, %HTTPoison.Error{reason: reason}} ->
    IO.inspect reason
end