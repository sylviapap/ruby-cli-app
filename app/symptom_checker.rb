require 'pry'
require 'rest-client'
require 'json'

def run_symptom_checker
    puts "Welcome to Symptom Checker"
    puts "Please enter male or female"
    sex_input = gets.chomp
    puts "Please enter your age"
    age_input = gets.chomp
    puts "Enter your symptoms. If this is an emergency please hang up and dial 911"
    symptom_input = gets.chomp
    # process_symptom_input(symptom_input)
    get_diagnosis_hash(sex_input, symptom_input)
end

# def process_symptom_input(symptom_input)
#     symptom_input.split(" ").join("+")
# end

def process_age_input(age_input)
    age_input.to_i
end

def get_symptom_hash(symptom_input)
    app_id = '582e2307'
    app_key = 'c98b58a9bf15795b1dacdfebe5375701'
    response = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{symptom_input}", headers={'App-Id' => app_id, 'App-Key' => app_key})
    symptom_hash = JSON.parse(response)
    symptom_hash
    # symptoms = symptom_hash.map{ |hash| hash["label"] }
    # puts symptoms
end

def get_diagnosis_hash(sex_input, symptom_input)
    app_id = '582e2307'
    app_key = 'c98b58a9bf15795b1dacdfebe5375701'
    new_array = get_symptom_hash(symptom_input).map do |hash|
        hash.delete_if {|key, value| key >= "label"}
        end
    array_of_hashes = new_array.each {|hash| hash['choice_id'] = 'present'}
    data_hash = {
    'sex' => sex_input,
    'age' => 40,
    'evidence' => array_of_hashes
    }
    payload = JSON.generate(data_hash)
    response = RestClient.post("https://api.infermedica.com/v2/diagnosis", payload, headers={'App-Id' => app_id, 'App-Key' => app_key, 'Content-Type' => 'application/json'})
    diagnosis_hash = JSON.parse(response)
    puts diagnosis_hash
    # diagnoses = diagnosis_hash.map{ |hash| hash[:conditions]}
end

# binding.pry
query = run_symptom_checker
    # binding.pry
# get_diagnosis_hash(query)

puts "hello"