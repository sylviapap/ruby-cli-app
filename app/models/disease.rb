class Disease < ActiveRecord::Base
    has_many :patient_diseases
    has_many :patients, through: :patient_diseases
    has_many :symptoms
    has_many :patients, through: :symptoms

end