require 'pry'
require 'rest-client'
require 'json'

app_id = '582e2307'
app_key = 'c98b58a9bf15795b1dacdfebe5375701'


symptoms = RestClient.get("https://api.infermedica.com/v2/symptoms", headers={'App-Id' => app_id, 'App-Key' => app_key})

diseases = RestClient.get("https://api.infermedica.com/v2/conditions", headers={'App-Id' => app_id, 'App-Key' => app_key})

info = RestClient.get("https://api.infermedica.com/v2/info", headers={'App-Id' => app_id, 'App-Key' => app_key})

risk_factors = RestClient.get("https://api.infermedica.com/v2/risk_factors", headers={'App-Id' => app_id, 'App-Key' => app_key})

search = RestClient.get("https://api.infermedica.com/v2/search?phrase=cough", headers={'App-Id' => app_id, 'App-Key' => app_key})

search_hash = JSON.parse(search)

new_array = search_hash.map do |hash|
    hash.delete_if {|key, value| key >= "label"}
    end
array_of_hashes = new_array.each {|hash| hash['choice_id'] = 'present'}

symptoms_hash = JSON.parse(symptoms)
diseases_hash = JSON.parse(diseases)
info_hash = JSON.parse(info)
risk_factors_hash = JSON.parse(risk_factors)


data_hash = {
    'sex' => 'female',
    'age' => 25,
    'evidence' => array_of_hashes
}

payload = JSON.generate(data_hash)

diagnosis = RestClient.post("https://api.infermedica.com/v2/diagnosis", payload, headers = {'App-Id' => app_id, 'App-Key' => app_key, 'Content-Type' => 'application/json'})

diagnosis_hash = JSON.parse(diagnosis)

def process_user_input(user_input)
  user_input.split(" ").join("+")
end

binding.pry
puts 'hi'