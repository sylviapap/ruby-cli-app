class CreatePatients < ActiveRecord::Migration[5.0]
    def change
        create_table :patients do |p|
            p.string :name
            p.integer :age
            p.string :sex
            p.string :symptoms
        end
    end
end