class CreateDisease < ActiveRecord::Migration [5.2]
    def change
        create_table :diseases do |d|
            d.string :name
            d.text :symptom
    end
end