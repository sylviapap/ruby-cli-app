require 'pry'
require 'rest-client'
require 'json'

app_id = '582e2307'
app_key = 'c98b58a9bf15795b1dacdfebe5375701'

### info
info = RestClient.get("https://api.infermedica.com/v2/info", headers={'App-Id' => app_id, 'App-Key' => app_key})
info_hash = JSON.parse(info)
###

### all symptoms
symptoms = RestClient.get("https://api.infermedica.com/v2/symptoms", headers={'App-Id' => app_id, 'App-Key' => app_key})
symptoms_hash = JSON.parse(symptoms)
###

### diseases
result = RestClient.get("https://api.infermedica.com/v2/conditions", headers={'App-Id' => app_id, 'App-Key' => app_key})
disease_array = JSON.parse(result)
name_array = disease_array.map do |hash|
  hash.select {|key, value| key >= "name"}
  end

### search
search_term = "cough"
search = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{search_term}", headers={'App-Id' => app_id, 'App-Key' => app_key})
search_hash = JSON.parse(search)
###

### search risk factors
rfsearch = "injury"
rf_req = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{rfsearch}&type=risk_factor", headers={'App-Id' => app_id, 'App-Key' => app_key})
rf_result = JSON.parse(rf_req)
###

### risk factors
risk_factors = RestClient.get("https://api.infermedica.com/v2/risk_factors", headers={'App-Id' => app_id, 'App-Key' => app_key})
risk_factors_hash = JSON.parse(risk_factors)
###

### diagnosis
new_array = search_hash.map do |hash|
  hash.delete_if {|key, value| key >= "label"}
  end
array_of_hashes = new_array.each {|hash| hash['choice_id'] = 'present'}
data_hash = {
    'sex' => 'female',
    'age' => 25,
    'evidence' => array_of_hashes
}
payload = JSON.generate(data_hash)
diagnosis = RestClient.post("https://api.infermedica.com/v2/diagnosis", payload, headers = {'App-Id' => app_id, 'App-Key' => app_key, 'Content-Type' => 'application/json'})
diagnosis_hash = JSON.parse(diagnosis)
###



binding.pry
puts 'hi'