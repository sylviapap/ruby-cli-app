require 'pry'
require 'rest-client'
require 'json'

app_id = '582e2307'
app_key = 'c98b58a9bf15795b1dacdfebe5375701'
symptoms = RestClient.get("https://api.infermedica.com/v2/symptoms", headers={'App-Id' => app_id, 'App-Key' => app_key})

diseases = RestClient.get("https://api.infermedica.com/v2/conditions", headers={'App-Id' => app_id, 'App-Key' => app_key})

info = RestClient.get("https://api.infermedica.com/v2/info", headers={'App-Id' => app_id, 'App-Key' => app_key})

data_hash = {
    'sex' => 'female',
    'age' => 25,
    'evidence' => [
      {'id' => 's_47', 'choice_id' => 'present', 'initial' => true},
      {'id' => 's_22', 'choice_id' => 'present', 'initial' => true},
      {'id' => 'p_81', 'choice_id' => 'absent'}
    ]
}

payload = JSON.generate(data_hash)

# binding.pry

diagnosis = RestClient.post("https://api.infermedica.com/v2/diagnosis", payload, headers = {'App-Id' => app_id, 'App-Key' => app_key, 'Content-Type' => 'application/json'}
)

symptoms_hash = JSON.parse(symptoms)
diseases_hash = JSON.parse(diseases)
info_hash = JSON.parse(info)
diagnosis_hash = JSON.parse(diagnosis)
# binding.pry
puts 'hi'