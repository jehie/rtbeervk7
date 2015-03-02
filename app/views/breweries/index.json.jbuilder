json.array!(@retired_breweries+ @active_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year, :beers
end
