class Printer < ActiveRecord::Base
	validates :name, presence: true
	has_many :printer_services
	belongs_to :hardware_state
	accepts_nested_attributes_for :printer_services, :hardware_state, :reject_if => :all_blank, :allow_destroy => true
end
