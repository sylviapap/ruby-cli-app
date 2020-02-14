require 'pry'
require 'rest-client'
require 'json'
# require_relative '../config/environment.rb'

def welcome
    puts "Welcome to Symptom Checker"
    puts "To check your symptoms against potential diseases, press 1."
    puts "To view all possible diseases in the database, press 2."
    puts "To view all possible symptoms, press 3."
    puts "To exit Symptom Checker, press any other key."
    response = gets.chomp
    if response == "1"
        run_symptom_checker
        # puts "Press 9 to return to main menu"
    elsif response == "2"
        result = Disease.pluck(:name)  
        puts result
    elsif response == "3"
        ## get seeded symptom data from db
    elsif response == "4"
        ##exit SC
    elsif response == "9"
        welcome   
    end
end

def run_symptom_checker
    puts "Please enter your name"
    name_input = gets.chomp
    puts "Please enter male or female"
    sex_input = gets.chomp.downcase
    puts "Please enter your age"
    age_input = gets.chomp
    puts "Enter your symptoms. If this is an emergency please hang up and dial 911"
    symptom_input = gets.chomp
    # patient = Patient.create(name: name_input, age: age_input, sex: sex_input)
    # 
    # process_symptom_input(symptom_input)
    patient = save_patient(name_input, age_input, sex_input)
    get_diagnosis_hash(sex_input, age_input, symptom_input, patient)
    puts "Press 9 to run Symptom Checker again."
    num_response = gets.chomp
    if num_response == "9"
        welcome
    end
    
end

def process_age_input(age_input)
    age_input.to_i
end

def get_symptom_hash(symptom_input)
    app_id = '582e2307'
    app_key = 'c98b58a9bf15795b1dacdfebe5375701'
    response = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{symptom_input}", headers={'App-Id' => app_id, 'App-Key' => app_key})
    response_array = JSON.parse(response)
    # symptom_names_array = response_array.map{ |hash| hash["label"]}
    # Symptom.create(patient_id: patient.id, disease_id: disease.id, name: symptom_hash[""])
    # symptoms = symptom_hash.map{ |hash| hash["label"] }
    # puts symptoms
end

def save_patient(name_input, age_input, sex_input)
    Patient.find_or_create_by(name: name_input, age: age_input, sex: sex_input)
end

def get_diagnosis_hash(sex_input, age_input, symptom_input, patient)
    app_id = '582e2307'
    app_key = 'c98b58a9bf15795b1dacdfebe5375701'
    new_array = get_symptom_hash(symptom_input).map do |hash|
        hash.delete_if {|key, value| key >= "label"}
        end
    array_of_hashes = new_array.each {|hash| hash['choice_id'] = 'present'}
    data_hash = {
    'sex' => sex_input,
    'age' => age_input,
    'evidence' => array_of_hashes
    }
    payload = JSON.generate(data_hash)
    response = RestClient.post("https://api.infermedica.com/v2/diagnosis", payload, headers={'App-Id' => app_id, 'App-Key' => app_key, 'Content-Type' => 'application/json'})
    diagnosis_hash = JSON.parse(response)
    diagnosis_names = diagnosis_hash["conditions"].map { |cond| cond["name"]}
    puts diagnosis_names
    diagnosis_names.each do |name| 
        disease = Disease.find_by(name: name)
        PatientDisease.find_or_create_by(patient_id: patient.id, disease_id: disease.id)
    end
end



# def  save_patient_disease(disease_id, patient_id)
#     PatientDisease.find_or_create_by(disease_id:, patient_id:)
# end

# binding.pry
puts 'hi'