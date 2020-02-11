require 'pry'
require 'rest-client'
require 'json'

def run_symptom_checker
    puts "Welcome to Symptom Checker"
    puts "Enter your symptoms. If this is an emergency please hang up and dial 911"
    user_input = gets.chomp
    process_user_input(user_input)
end

def process_user_input(user_input)
    user_input.split(" ").join("+")
end

def get_symptom_hash(user_input)
    app_id = '582e2307'
    app_key = 'c98b58a9bf15795b1dacdfebe5375701'
    response = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{user_input}", headers={'App-Id' => app_id, 'App-Key' => app_key})
    symptom_hash = JSON.parse(response)
    symptoms = symptom_hash.map{ |hash| hash["label"] }
    puts symptoms
end

query = run_symptom_checker
get_symptom_hash(query)