app_id = '582e2307'
app_key = 'c98b58a9bf15795b1dacdfebe5375701'

result = RestClient.get("https://api.infermedica.com/v2/conditions", headers={'App-Id' => app_id, 'App-Key' => app_key})
disease_array = JSON.parse(result)
name_array = disease_array.map do |hash|
    hash.select {|key, value| key >= "name"}
    end
name_array.each {|disease| Disease.create(name: disease["name"])}

