require 'pry'
require 'rest-client'
require 'json'

def start
    curly_break
    puts '                 .'
    puts ''
    puts '                   .'
    puts '         /^\     .'
    puts '    /\   "V"'
    puts '   /__\   I      O  o'
    puts '  /|..|\  I     .'
    puts '  \].`[/  I'
    puts '  /l\/j\  (]    .  O'
    puts ' /. ~~ ,\/I          .'
    puts ' \ L__j^\/I       o'
    puts '  \/--v}  I     o   .'
    puts '  |    |  I   _________'
    puts "  |    |  I c(`       ')o"
    puts '  |    l  I   \.     ,/'
    puts '_/   L l\_! _/ /^---^\ \_ '
    puts ''
    puts '~*~*~*~*~*  Welcome to Symptom Wizard!!!!!!! ~*~*~*~*~*'
    curly_break
    puts "If this is an emergency please hang up and dial 911"
    curly_break
    welcome
end

def curly_break
    puts ""
    puts '~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~'
    puts ""
end

def format(result)
    curly_break
    puts result
    curly_break
end

def welcome
    puts "1  -  To check your symptoms against potential diseases, enter 1."
    puts "2  -  To view all possible diseases in the database, enter 2."
    puts "3  -  To search from a list of risk factors, enter 3."
    puts "4  -  To search for a possible disease, enter 4"
    puts "5  -  To view saved diseases, enter 5."
    puts "6  -  To start over, enter 6"
    puts "7  -  To exit Symptom Checker, enter any other key."
    response = gets.chomp
    if response == "1"
        run_symptom_checker
    elsif response == "2"
        result = Disease.pluck(:name)  
        puts result
        puts "Enter 9 to return to Symptom Wizard"
        response_after_listing_diseases = gets.chomp
        if response_after_listing_diseases == "9"
            welcome
        end
        format(result)
    elsif response == "3"
        puts "Search for risk factors. I.e. enter 'injury'."
        rfsearch = gets.chomp
        app_id = "582e2307"
        app_key = "c98b58a9bf15795b1dacdfebe5375701"
        rf_req = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{rfsearch}&type=risk_factor", headers={'App-Id' => app_id, 'App-Key' => app_key})
        rf_json = JSON.parse(rf_req)
        rf_result = rf_json.map{ |hash| hash["label"]}
        puts format(rf_result)
        puts "Enter 9 to return to Symptom Wizard"
        risk_response = gets.chomp
        if risk_response == "9"
            welcome
        end
    elsif response == "4"
        puts "Enter the disease you'd like to search for."
        search_res = gets.chomp.capitalize
        disease_res = Disease.where("name like ?", "%#{search_res}%")
        puts disease_res.map(&:name)
        puts "Enter 9 to return to Symptom Wizard."
        run_again = gets.chomp
        if run_again == "9"
            welcome
        end  
    elsif response == "5"
        view_patient_diseases
        puts "Enter 9 to return to Symptom Wizard"
        pd_response = gets.chomp
        if pd_response == "9"
            welcome
        end
    elsif response == "6"    
        welcome 
    end
end

def run_symptom_checker
    puts "Please enter your name"
    name_input = gets.chomp
    puts "Please enter 'male' or 'female'"
    sex_input = gets.chomp.downcase
    while sex_input != "male" && sex_input != "female"
        puts "Not a valid entry!"
        puts "Please enter 'male' or 'female'"
        sex_input = gets.chomp.downcase
    end
    puts "Please enter your age"
    age_input = gets.chomp.to_i
    puts "Enter a symptom"
    symptom_input = gets.chomp
    patient = save_patient(name_input, age_input, sex_input)
    get_diagnosis(sex_input, age_input, symptom_input, patient)
    puts ""
    puts "Enter 9 to run Symptom Wizard again."
    puts ""
    puts "Enter 5 to view all of your possible diseases."
    puts ""
    puts "Enter any other key to exit."
    puts ""
    num_response = gets.chomp
    if num_response == "9"
        run_symptom_checker
    end
    if num_response == "5"
        view_patient_diseases
    end
end

def get_symptoms(symptom_input)
    app_id = "582e2307"
    app_key = "c98b58a9bf15795b1dacdfebe5375701"
    response = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{symptom_input}", headers={'App-Id' => app_id, 'App-Key' => app_key})
    response_array = JSON.parse(response)
    # symptom_names_array = response_array.map{ |hash| hash["label"]}
    # Symptom.create(patient_id: patient.id, disease_id: disease.id, name: symptom_hash[""])
    # symptoms = symptom_hash.map{ |hash| hash["label"] }
    # puts symptoms
end

def save_patient(name_input, age_input, sex_input)
    patient = Patient.find_or_create_by(name: name_input, age: age_input, sex: sex_input)
end

def get_diagnosis(sex_input, age_input, symptom_input, patient)
    app_id = "582e2307"
    app_key = "c98b58a9bf15795b1dacdfebe5375701"
    new_array = get_symptoms(symptom_input).map do |hash|
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
    format(diagnosis_names)
    diagnosis_names.each do |name| 
        disease = Disease.find_by(name: name)
        PatientDisease.find_or_create_by(patient_id: patient.id, disease_id: disease.id)
    end
end

def view_patient_diseases
    puts format("Enter your name (exactly as you entered before)")
    name_input = gets.chomp
    patient = Patient.find_by(name: name_input)
    patient_diseases = PatientDisease.where(patient_id: patient.id)
    result = patient_diseases.map {|pd| Disease.where(id: pd.disease_id).pluck(:name)}
    puts format(result)
    puts "Enter 9 to return to Symptom Wizard."
    vpd_response = gets.chomp
    if vpd_response == "9"
        welcome
    end
end
