class CreatePatientDisease < ActiveRecord::Migration [5.2]
    def change 
        create_table :patient_diseases do |p|
            p.integer :disease_id
            p.integer :patient_id
            p.string :name
    end
end