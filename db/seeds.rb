require 'pry'
require 'rest-client'
require 'json'

app_id = '582e2307'
app_key = 'c98b58a9bf15795b1dacdfebe5375701'

response = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{user_input}", headers={'App-Id' => app_id, 'App-Key' => app_key})

# binding.pry
puts 'hi'