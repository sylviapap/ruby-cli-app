require 'pry'
require 'rest-client'
require 'json'
require 'io/console'

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
    puts ""
    puts "1  -  To check your symptoms against potential diseases, Press 1."
    puts "2  -  To view all possible diseases in the database, Press 2."
    puts "3  -  To search from a list of risk factors, Press 3."
    puts "4  -  To search for a possible disease, Press 4."
    puts "5  -  To view saved diseases, Press 5."
    puts "6  -  To return to main menu, Press 6."  
    puts "7  -  To exit Symptom Wizard, Press any other key."
    puts ""
    response = STDIN.getch
    if response == "1"
        run_symptom_checker
    elsif response == "2"
        result = Disease.pluck(:name)  
        format(result)
        puts "Press 4 to search for a disease."
        puts "Press 6 to return to main menu."
        response_after_listing_diseases = STDIN.getch
        if response_after_listing_diseases == "6"
            welcome
        elsif response_after_listing_diseases == "4"
            disease_search
        end
    elsif response == "3"
        puts "Search for risk factors. For example, enter 'injury'"
        rfsearch = gets.chomp
        app_id = "582e2307"
        app_key = "c98b58a9bf15795b1dacdfebe5375701"
        rf_req = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{rfsearch}&type=risk_factor", headers={'App-Id' => app_id, 'App-Key' => app_key})
        rf_json = JSON.parse(rf_req)
        if rf_json.empty?
            format("Nothing found!")
        end
        rf_result = rf_json.map{ |hash| hash["label"]}
        puts format(rf_result)
        puts "Press 6 to return to main menu"
        risk_response = STDIN.getch
        if risk_response == "6"
            welcome
        end
    elsif response == "4"
        disease_search
    elsif response == "5"
        view_patient_diseases
        puts "Press 6 to return to main menu"
        pd_response = STDIN.getch
        if pd_response == "6"
            welcome
        end
    elsif response == "6"    
        welcome
    elsif response 
    end
end

def disease_search
    puts ""
    puts "Enter the disease you'd like to search for:"
    search_res = gets.chomp.capitalize
    disease_res = Disease.where("name like ?", "%#{search_res}%")
    if disease_res.empty?
        format("Nothing found!")
    end
    puts format(disease_res.map(&:name))
    puts "Press 4 to search diseases again."
    puts "Press any other key to return to main menu."
    run_again = STDIN.getch
    if run_again == "4"
        disease_search
    elsif run_again
        welcome
    end
end

def run_symptom_checker

        ###### auth

    app_id = "582e2307"
    app_key = "c98b58a9bf15795b1dacdfebe5375701"

        ##### prompts and inputs

    puts "Please enter your name:"
    name_input = gets.chomp
    puts "Please enter 'male' or 'female':"
    sex_input = gets.chomp.downcase
    while sex_input != "male" && sex_input != "female"
        puts "Not a valid entry!"
        puts "Please enter 'male' or 'female':"
        sex_input = gets.chomp.downcase
    end
    puts "Please enter your age:"
    age_input = gets.chomp.to_i
    puts "Enter a symptom (i.e. 'cough')"
    symptom_input = gets.chomp
        
        ######## save patient
    
    patient = Patient.find_or_create_by(name: name_input, age: age_input, sex: sex_input)
    
        ######### get symptoms
    
    symptom_request = RestClient.get("https://api.infermedica.com/v2/search?phrase=#{symptom_input}&type=symptom", headers={'App-Id' => app_id, 'App-Key' => app_key})
    symptom_json = JSON.parse(symptom_request)
    if symptom_json.empty?
        format("Nothing found!")
    end

        ######### save symptoms

    names = symptom_json.map{ |hash| hash["label"]}
    names.each do |n| 
        patient = Patient.find_by(name: name_input)
        Symptom.find_or_create_by(patient_id: patient.id, name: n)
    end

        ######### symptoms IDs

    symptom_search_ids = symptom_json.map do |hash|
        hash.delete_if {|key, value| key >= "label"}
        end
    
        ######### get diagnosis
    
    evidence_requirement = symptom_search_ids.each {|hash| hash['choice_id'] = 'present'}
    data_hash = {
    'sex' => sex_input,
    'age' => age_input,
    'evidence' => evidence_requirement
    }
    payload = JSON.generate(data_hash)
    d_request = RestClient.post("https://api.infermedica.com/v2/diagnosis", payload, headers={'App-Id' => app_id, 'App-Key' => app_key, 'Content-Type' => 'application/json'})
    d_json = JSON.parse(d_request)
    d_names = d_json["conditions"].map { |cond| cond["name"]}
    if d_names.empty?
        format("No diagnosis found! Sorry")
    else
        format(d_names)
    end
    d_names.each do |name| 
        disease = Disease.find_by(name: name)
        PatientDisease.find_or_create_by(patient_id: patient.id, disease_id: disease.id)
    end

        ###### continue prompts

    puts ""
    puts "Press 9 to run Symptom Wizard again."
    puts ""
    puts "Press 5 to view all of your possible diseases."
    puts ""
    puts "Press any other key to return to main menu."
    puts ""
    num_response = STDIN.getch
    if num_response == "9"
        run_symptom_checker
    elsif num_response == "5"
        view_patient_diseases
    elsif num_response
        welcome
    end
end

    ######## end symptom checker main

def view_patient_diseases
    puts format("Enter your name (exactly as you entered before)")
    name_input = gets.chomp
    patient = Patient.find_or_create_by(name: name_input)
    patient_diseases = PatientDisease.where(patient_id: patient.id)
    if patient_diseases.empty?
        format("None found! Sorry")
    else
        result = patient_diseases.map {|pd| Disease.where(id: pd.disease_id).pluck(:name)}
        format(result)
    end
    puts "Press any key to return to main menu."
    vpd_response = STDIN.getch
    if vpd_response
        welcome
    end
end
