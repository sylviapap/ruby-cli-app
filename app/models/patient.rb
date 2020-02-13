class Patient < ActiveRecord::Base
    has_many :patient_diseases
    has_many :symptoms
    has_many :diseases, through: :patient_diseases
    has_many :diseases, through: :symptoms
end