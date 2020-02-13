class CreatePatientDiseases < ActiveRecord::Migration[5.0]
    def change 
        create_table :patient_diseases do |p|
            p.integer :disease_id
            p.integer :patient_id
            p.string :name
        end
    end
end 