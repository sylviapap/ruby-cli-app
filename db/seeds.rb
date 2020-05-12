app_id = ENV["INFERMEDICA_APP_ID"]
app_key = ENV["INFERMEDICA_APP_KEY"]

result = RestClient.get("https://api.infermedica.com/v2/conditions", headers={"App-Id" => "#{app_id}", "App-Key" => "#{app_key}"})
disease_array = JSON.parse(result)
name_array = disease_array.map do |hash|
    hash.select {|key, value| key >= "name"}
    end
name_array.each {|disease| Disease.create(name: disease["name"])}