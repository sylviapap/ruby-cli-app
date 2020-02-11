class CreatePatients < ActiveRecord::Migration[5.2]
    def change
        create_table :patients do |p|
            p.string :name
            p.integer :age
            p.integer :height
            p.integer :weight
            p.string :gender
        end
    end
end