class Disease < ActiveRecord::Base
    has_many :patients
    has_many :patient_diseases, through: :patients

    
end