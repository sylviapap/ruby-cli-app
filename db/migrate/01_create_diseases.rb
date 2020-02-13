class CreateDiseases < ActiveRecord::Migration[5.0]
    def change
        create_table :diseases do |d|
            d.string :name
        end
    end
end