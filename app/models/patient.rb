class Patient < ActiveRecord::Base
    has_many :diseases
    has_many :symptoms, through: :diseases

    def find_or_create_and_save
        Patient.create
    end
end